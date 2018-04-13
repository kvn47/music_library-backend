class Album::Index < BaseOperation
  step :artist!
  failure ->(options, **) { options['result.message'] = 'Artist not found!' }
  step :model!

  def artist!(options, params:, **)
    return true unless params.key? :artist_id
    options['artist'] = Artist.find_by(id: params[:artist_id])
  end

  def model!(options, artist: nil, **)
    albums = artist.nil? ? Album.ordered : artist.albums
    options[:model] = albums
  end
end