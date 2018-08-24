class TrackRepresenter < ARepresenter
  include ActiveSupport::NumberHelper

  property :id
  property :title
  property :number
  property :size, exec_context: :decorator
  property :artist_name, exec_context: :decorator

  def size
    number_to_human_size represented.size
  end

  def artist_name
    represented.artist.name
  end
end
