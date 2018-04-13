class ExportList::Add < BaseOperation
  step Model(ExportList, :find_by)
  step :find_artist!
  step :find_album!
  step :find_track!
  failure :record_not_found!, fail_fast: true
  step :process!
  step :message!
  failure :error!

  def process!(*, model:, tracks:, **)
    tracks.each do |track|
      model.tracks << track
    end
    model.update_size
  end

  def find_artist!(options, params:, **)
    return true unless params.key? :artist_id
    artist = Artist.find params[:artist_id]
    options['tracks'] = artist.tracks.to_a
  end

  def find_album!(options, params:, **)
    return true unless params.key? :album_id
    album = Album.find params[:album_id]
    options['tracks'] = album.tracks.to_a
  end

  def find_track!(options, params:, **)
    return true unless params.key? :track_id
    track = Track.find(params[:track_id])
    options['tracks'] = [track]
  end

  def message!(options, **)
    options['result.message'] = 'Track added'
  end

  def error!(options, **)
    options['result.message'] = 'Track not added!!!'
  end
end