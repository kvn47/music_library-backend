class Tracklist::AddTracks < BaseOperation
  step Model(Tracklist, :find_by)
  step :find_artist_tracks!
  step :find_album_tracks!
  step :find_track!
  failure :record_not_found!, fail_fast: true
  step :add_tracks!
  step :message!
  failure :error!

  private

  def find_artist_tracks!(options, params:, **)
    return true unless params.key? :artist_id
    artist = Artist.find params[:artist_id]
    options['tracks'] = artist.tracks.to_a
  end

  def find_album_tracks!(options, params:, **)
    return true unless params.key? :album_id
    album = Album.find params[:album_id]
    options['tracks'] = album.tracks.to_a
  end

  def find_track!(options, params:, **)
    return true unless params.key? :track_id
    track = Track.find(params[:track_id])
    options['tracks'] = [track]
  end

  def add_tracks!(_, model:, tracks:, **)
    tracks.each do |track|
      model.tracks << track
    end
  end

  def message!(options, **)
    options['result.message'] = 'Track added'
  end

  def error!(options, **)
    options['result.message'] = 'Track not added!!!'
  end
end