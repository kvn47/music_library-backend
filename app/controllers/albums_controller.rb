class AlbumsController < BaseController
  def index
    albums = Album.query(**action_params)
    represent albums
  end
end
