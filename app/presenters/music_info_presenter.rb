# frozen_string_literal: true

class MusicInfoPresenter < Grape::Entity
  expose :cue
  expose :file
  expose :images
  expose :mb_release
  expose :mb_release_url
  expose :albums, using: AlbumInfoPresenter
end
