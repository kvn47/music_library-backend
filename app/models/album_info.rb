class AlbumInfo
  attr_accessor :title, :year, :artist, :album_artist, :composer, :cover, :tracks

  def initialize(**attributes)
    attributes.each do |name, value|
      self.send("#{name}=", value)
    end
  end

  def tracks
    @tracks ||= []
  end

  def tracks=(new_value)
    if new_value.is_a?(Array)
      @tracks = new_value
    else
      @tracks = [new_value]
    end
  end
end
