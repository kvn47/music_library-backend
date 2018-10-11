class ArtistRepresenter < ARepresenter
  property :id
  property :name
  property :url, exec_context: :decorator
  property :image_thumb_url

  def url
    "/artists/#{represented.id}"
  end
end