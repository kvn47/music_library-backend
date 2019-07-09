class TrackPresenter < Grape::Entity
  include ActiveSupport::NumberHelper

  expose :id
  expose :title
  expose :number
  expose :size do |track, _|
    number_to_human_size(track.size)
  end
  expose :artist_name do |track, _|
    track.artist.name
  end
end
