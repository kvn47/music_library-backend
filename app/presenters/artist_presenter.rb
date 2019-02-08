class ArtistPresenter < Grape::Entity
  expose :id
  expose :name
  expose :url
  expose :image_thumb_url

  private

  def url
    "/artists/#{object.id}"
  end
end