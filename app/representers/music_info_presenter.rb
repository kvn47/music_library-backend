# frozen_string_literal: true

class MusicInfoPresenter < Grape::Entity
  expose :cue
  expose :file
  expose :images
  expose :mb_release
  expose :mb_release_url

  expose :albums do
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

    expose :tracks do
      expose :number
      expose :title
      expose :cue_track
      expose :file
      expose :mb_length
      expose :mbid
      expose :mb_url
    end
  end
end
