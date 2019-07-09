class ArtistPresenter < Grape::Entity
  expose :id
  expose :name
  expose :image_thumb_url, unless: {type: :full}

  with_options(if: {type: :full}) do
    expose :image_url
    expose :mb_id
    expose :albums, using: AlbumPresenter
  end
end
