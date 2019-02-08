class AlbumInfoPresenter < Grape::Entity
  expose :artist
  expose :mb_artists
  expose :album_artist
  expose :mb_composer
  expose :mb_composer_id
  expose :mb_composer_url
  expose :title
  expose :mb_title
  expose :genre
  expose :year
  expose :mb_date
  expose :cover
  expose :mb_url
  expose :tracks, using: TrackInfoPresenter
end
