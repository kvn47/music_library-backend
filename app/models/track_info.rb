class TrackInfo
  attr_accessor :number, :title, :album, :artist, :year, :genre, :path

  def initialize(**attributes)
    attributes.each do |name, value|
      self.send("#{name}=", value)
    end
  end
end
