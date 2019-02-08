class AlbumPresenter < Grape::Entity
  expose :id
  expose :title
  expose :url
  expose :cover_thumb_url

  private

  def url
    "/albums/#{object.id}"
  end
end
