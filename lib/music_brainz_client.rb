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
    return call("release/#{mbid}", params.merge(inc: 'recordings+work-level-rels'))[:release] if mbid
    releases = search_release(artist: artist, title: title)
    return nil if releases.empty?
    response = release(releases[0][:id])
    response[:release]
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
    call "work/#{mbid}", params
  end

  private

  def call(resource, params = {})
    response = self.class.get("/#{resource}", query: params)
    raise ArgumentError, response.parsed_response if response.response.is_a?(Net::HTTPBadRequest)
    raise response.message if response.response.is_a?(Net::HTTPUnauthorized)
    Mash.new(response).metadata
  end
end
