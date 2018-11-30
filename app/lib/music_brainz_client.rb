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

  def release(mbid: nil, artist: nil, title: nil, **params)
    return lookup_release(mbid, params) if mbid
    releases = search_release(artist: artist, title: title)
    return nil if releases.empty?
    lookup_release(releases[0][:id], params)
  end

  def lookup_release(mbid, **params)
    # response = call("release/#{mbid}", params.merge(inc: 'recordings+work-level-rels+recording-rels+recording-level-rels'))
    response = call("release/#{mbid}", params.merge(inc: 'recordings+recording-rels+release-rels+work-rels+recording-level-rels+work-level-rels'))
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
    call("work/#{mbid}", params.merge(inc: 'work-rels'))
  end

  def search_work(artist:, name:)
    call('work', query: "artist:#{artist} AND name:#{name}")
  end

  private

  def call(resource, params = {})
    response = self.class.get("/#{resource}", query: params)
    raise ArgumentError, response.parsed_response if response.response.is_a?(Net::HTTPBadRequest)
    raise response.message if response.response.is_a?(Net::HTTPUnauthorized)
    Mash.new(response).metadata
  end

  def parse_release(release)
    tracks = release[:medium_list][:medium][:track_list][:track].map do |mb_track|
      track = {
        number: mb_track[:number].to_i,
        length: mb_track[:recording][:length],
        title: mb_track[:recording][:title],
        id: mb_track[:recording][:id],
      }

      work_part = find_work_part(mb_track)
      if work_part
        track[:work_part] = work_part.symbolize_keys.slice(:id, :title)
        work = find_work(work_part)
        if work
          track[:work] = work.symbolize_keys
          artists = find_artists(work)
          track[:artists] = artists if artists
        end
      end

      track
    end

    {
      title: release[:title],
      date: release[:date],
      id: release[:id],
      tracks: tracks
    }
  end

  def find_work_part(mb_track)
    mb_track.dig(:recording, :relation_list, :relation, :work)
  end

  def find_work(mb_work_part)
    mb_work_part[:relation_list]&.each do |relation_item|
      return relation_item.dig(:relation, :work) if relation_item[:target_type] == 'work'
    end
  end

  def find_artists(mb_work)
    response = call('artist', work: mb_work.id)
    artists = extract_list(response.dig(:artist_list), :artist)
    artists.map(&:name)
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
