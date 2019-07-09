class AlbumPresenter < Grape::Entity
  expose :id
  expose :title
  expose :cover_thumb_url, unless: {type: :full}

  with_options(if: {type: :full}) do
    expose :cover_url
    expose :mb_id
    expose :artist_id
    expose :artist_name
    expose :tracks, using: TrackPresenter
  end
end
