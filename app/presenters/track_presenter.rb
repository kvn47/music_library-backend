class TrackPresenter < Grape::Entity
  expose :id
  expose :title
  expose :number
  expose :size
  expose :artist_name

  private

  include ActiveSupport::NumberHelper

  def size
    number_to_human_size represented.size
  end

  def artist_name
    object.artist.name
  end
end
