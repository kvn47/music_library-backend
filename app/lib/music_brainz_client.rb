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

  def release(mbid: nil, artist: nil, title: nil, **params)
    return lookup_release(mbid, params) if mbid
    releases = search_release(artist: artist, title: title)
    return nil if releases.empty?
    lookup_release(releases[0][:id], params)
  end

  def lookup_release(mbid, **params)
    # response = call("release/#{mbid}", params.merge(inc: 'recordings+work-level-rels+recording-rels+recording-level-rels'))
    response = call("release/#{mbid}", params.merge(inc: 'recordings+recording-rels+release-rels+work-rels+artist-rels+recording-level-rels+work-level-rels'))
    # recordings = call('recording', release: response[:release][:id], inc: 'artist-credits')
    # works = call('work', recording: 'afa019dd-30f0-4053-86e2-603e6ae3c46c', inc: 'aliases')
    parse_release response[:release]
  end

  def search_release(artist:, title:)
    response = call('release', query: "artist:#{artist} AND title:#{title}")

    case response[:release_list][:count]
    when '0'
      []
    when '1'
      [response[:release_list][:release]]
    else
      response[:release_list][:release]
    end
  end

  def artist(mbid, **params)
    call "artist/#{mbid}", params.merge(inc: 'recordings+releases+release-groups')
  end

  def release_group(mbid, **params)
    call "release-group/#{mbid}", params.merge(inc: 'artists+releases')
  end

  def recording(mbid, **params)
    call "recording/#{mbid}", params
  end

  def work(mbid, **params)
    result = call("work/#{mbid}", params.merge(inc: 'artist-rels'))
    result[:work]
  end

  def search_work(artist:, name:)
    call('work', query: "artist:#{artist} AND name:#{name}")
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

    release.dig(:medium_list, :medium, :track_list, :track)&.each do |mb_track|
      mb_artists = []
      mb_composer = nil
      mb_work = nil
      work_part = nil

      mb_track.dig(:recording, :relation_list)&.each do |recording_relation|
        case recording_relation[:target_type]
        when 'artist'
          mb_artists = recording_relation[:relation]
        when 'work'
          mb_work_part = recording_relation[:relation][:work]

          work_part = WorkPart.new title: mb_work_part[:title],
                                   id: mb_work_part[:id],
                                   track_length: mb_track[:length],
                                   track_number: mb_track[:number].to_i

          mb_work_part[:relation_list].each do |work_relation|
            case work_relation[:target_type]
            when 'artist'
              mb_composer = work_relation[:relation] if work_relation[:relation][:type] == 'composer'
            when 'work'
              mb_work = work_relation[:relation][:work]
              work_part.number = work_relation[:relation][:ordering_key].to_i
            end
          end
        end
      end

      if works.key? mb_work[:id]
        works[mb_work[:id]].parts << work_part unless work_part.nil?
      else
        work = Work.new title: mb_work[:title], id: mb_work[:id]

        work.composer = Composer.new name: mb_composer[:artist][:name],
                                     begin: mb_composer[:begin],
                                     end: mb_composer[:end],
                                     id: mb_composer[:artist][:id]

        work.artists = mb_artists.map do |mb_artist|
          artist = Artist.new name: mb_artist[:artist][:sort_name], id: mb_artist[:artist][:id]
          artist.attributes = mb_artist.dig(:attribute_list, :attribute) if mb_artist[:type] == 'instrument'
          artist
        end

        work.parts = [work_part]
        works.store work.id, work
      end
    end

    works.values
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
