class Track::Index < BaseOperation
  step :album!
  step :model!

  def album!(options, params:, **)
    options['album'] = Album.find(params[:album_id]) if params.key? :album_id
  end

  def model!(options, album: nil, params:, **)
    tracks = album.nil? ? Track.ordered : album.tracks
    options[:model] = tracks
  end
end