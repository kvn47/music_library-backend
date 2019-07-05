require 'httparty'
require 'hashie'

class MusicBrainzClient
  include HTTParty
  include Hashie

  base_uri 'https://musicbrainz.org/ws/2'

  def initialize(username: nil, password: nil, **)
    self.class.digest_auth username, password if username && password
    self.class.headers 'User-Agent' => 'MusicLibrary/0.1.0'
  end

  def call(resource, params = {})
    response = self.class.get("/#{resource}", query: params)
    raise ArgumentError, response.parsed_response if response.response.is_a?(Net::HTTPBadRequest)
    raise response.message if response.response.is_a?(Net::HTTPUnauthorized)
    Mash.new(response).metadata
  end

  def release(mb_id: nil, title: nil, artist: nil, **params)
    return lookup_release(mb_id, params) if mb_id

    releases = search_release(title: title, artist: artist)
    return nil if releases.empty?

    lookup_release(releases[0][:id], params)
  end

  def lookup_release(mb_id, **params)
    # response = call("release/#{mb_id}", params.merge(inc: 'recordings+work-level-rels+recording-rels+recording-level-rels'))
    response = call("release/#{mb_id}", params.merge(inc: 'recordings+recording-rels+release-rels+work-rels+artist-rels+recording-level-rels+work-level-rels'))
    # recordings = call('recording', release: response[:release][:id], inc: 'artist-credits')
    # works = call('work', recording: 'afa019dd-30f0-4053-86e2-603e6ae3c46c', inc: 'aliases')
    parse_release response[:release]
  end

  def search_release(artist:, title:)
    result = call('release', query: "artist:#{artist} AND title:#{title}")
    extract_list result.release_list, :release
  end

  def work(mb_id: nil, title: nil, artist: nil, artist_mb_id: nil, **params)
    return lookup_work(mb_id, params) if mb_id

    works = if artist_mb_id
              search_work(alias: title, arid: artist_mb_id, **params)
            else
              search_work(work: title, artist: artist, **params)
            end

    return if works.empty?

    found_work = find_most_relevant_work(works, composer: artist)
    return if found_work.nil?

    lookup_work(found_work[:mb_id], params)
  end

  def lookup_work(mb_id, **params)
    result = call("work/#{mb_id}", params.merge(inc: 'artist-rels+work-rels'))
    work = parse_work(result[:work])

    if work[:parts].empty?
      work[:parts] << {
        number: 1,
        title: work[:title],
        url: work[:url]
      }
    end

    work
  end

  # def browse_work(artist_mb_id:, **params)
  #   result = call('work', artist: artist_mb_id, **params)
  #   extract_list result.work_list, :work
  # end

  def search_work(params)
    query = params.map { |key, value| [key, value].join(':') }.join(' AND ')
    result = call('work', query: query)
    extract_list result.work_list, :work
  end

  def artist(mb_id, **params)
    call "artist/#{mb_id}", params.merge(inc: 'recordings+releases+release-groups')
  end

  def search_artist(name:)
    result = call('artist', query: name)
    extract_list result.artist_list, :artist
  end

  def recording(mb_id, **params)
    call "recording/#{mb_id}", params
  end

  private

  Work = Struct.new(:title, :composer, :artists, :parts, :id, keyword_init: true) do
    def url
      "https://musicbrainz.org/work/#{id}"
    end
  end

  WorkPart = Struct.new(:number, :title, :track_length, :track_number, :id, keyword_init: true) do
    def url
      "https://musicbrainz.org/work/#{id}"
    end
  end

  Artist = Struct.new(:name, :attributes, :id, keyword_init: true) do
    def url
      "https://musicbrainz.org/artist/#{id}"
    end
  end

  Composer = Struct.new(:name, :begin, :end, :id, keyword_init: true) do
    def url
      "https://musicbrainz.org/artist/#{id}"
    end
  end

  def parse_release(release)
    works = {}

    mediums = extract_list(release[:medium_list], :medium)

    mediums[0].dig(:track_list, :track)&.each do |mb_track|
      mb_artists = []
      mb_composer = nil
      mb_work = nil
      work_part = nil

      mb_track.dig(:recording, :relation_list)&.each do |recording_relation|
        case recording_relation[:target_type]
        when 'artist'
          mb_artists = if recording_relation[:relation].kind_of?(Array)
                         recording_relation[:relation]
                       else
                         [recording_relation[:relation]]
                       end
        when 'work'
          mb_work_part = recording_relation[:relation][:work]

          work_part = WorkPart.new title: mb_work_part[:title],
                                   id: mb_work_part[:id],
                                   track_length: mb_track[:length],
                                   track_number: mb_track[:position].to_i

          mb_work_part[:relation_list].each do |work_part_relation_item|
            work_part_relation = work_part_relation_item[:relation]

            case work_part_relation_item[:target_type]
            when 'artist'
              if work_part_relation.kind_of?(Array)
                work_part_relation.each do |rel|
                  mb_composer = rel if rel[:type] == 'composer'
                end
              elsif work_part_relation[:type] == 'composer'
                mb_composer = work_part_relation
              end
            when 'work'
              if work_part_relation.kind_of?(Array)
                work_part_relation = work_part_relation.find do |rel|
                  rel[:type] == 'parts'
                end
              end
              if work_part_relation.present?
                mb_work = work_part_relation[:work]
                work_part.number = work_part_relation[:ordering_key].to_i
              end
            else
              work_part_relation_item
            end
          end
        end
      end

      if mb_work.present?
        if works.key?(mb_work[:id])
          works[mb_work[:id]].parts << work_part unless work_part.nil?
        else
          work = Work.new title: mb_work[:title], artists: [], id: mb_work[:id]

          work.composer = Composer.new name: mb_composer[:artist][:name],
                                       begin: mb_composer[:begin],
                                       end: mb_composer[:end],
                                       id: mb_composer[:artist][:id]

          mb_artists.each do |mb_artist|
            next unless mb_artist.type.in? %w[instrument conductor]

            artist = Artist.new name: mb_artist[:artist][:sort_name], id: mb_artist[:artist][:id]
            artist.attributes = mb_artist.dig(:attribute_list, :attribute) if mb_artist.type == 'instrument'
            work.artists << artist
          end

          work.parts = [work_part]
          works.store work.id, work
        end
      else
        Rails.logger.info('[INFO] work not found')
      end
    end

    {
      title: release[:title],
      url: "https://musicbrainz.org/release/#{release[:id]}",
      works: works.values
    }
  end

  def find_most_relevant_work(mb_works, composer: nil)
    found_work = nil

    mb_works.each do |mb_work|
      work = parse_work(mb_work)

      if mb_work.score == '100'
        found_work = work
        break
      end

      next if composer.present? && work[:composer].present? && work[:composer] != composer

      found_work = work
      break
    end

    found_work
  end

  def parse_work(mb_work)
    work = {
      mb_id: mb_work[:id],
      title: mb_work[:title],
      url: "https://musicbrainz.org/work/#{mb_work[:id]}"
    }

    composer = nil
    parts = []

    work_relation_list = mb_work[:relation_list].kind_of?(Array) ? mb_work[:relation_list] : [mb_work[:relation_list]]

    work_relation_list.each do |work_relation_item|
      next if work_relation_item.nil?

      case work_relation_item[:target_type]
      when 'artist'
        if work_relation_item[:relation].kind_of?(Array)
          work_relation_item[:relation].each do |relation_item|
            composer = relation_item if relation_item[:type] == 'composer'
          end
        elsif work_relation_item.dig(:relation, :type) == 'composer'
          composer = work_relation_item[:relation]
        end
      when 'work'
        if work_relation_item[:relation].kind_of?(Array)
          work_relation_item[:relation].each do |relation_item|
            next unless relation_item[:type] == 'parts'

            parts << {
              number: relation_item[:ordering_key].to_i,
              title: relation_item[:work][:title],
              url: "https://musicbrainz.org/work/#{relation_item[:work][:id]}"
            }
          end
        end
      end
    end

    if composer
      work[:composer] = composer[:artist][:name]
      work[:composer_url] = "https://musicbrainz.org/artist/#{composer[:artist][:id]}"
      work[:date] = composer[:end]
    end

    work[:parts] = parts
    work
  end

  def extract_list(list, key)
    case list[:count]
    when '0'
      []
    when '1'
      [list[key]]
    else
      list[key]
    end
  end
end
