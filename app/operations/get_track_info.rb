require 'taglib'

class GetTrackInfo
  include ACallable

  def call(file_path)
    info = TrackInfo.new
    info.file = file_path

    TagLib::FileRef.open(file_path) do |ref|
      if ref.null?
        reg = /^(?<number>\d{2})\s?[-.]\s(?<title>.+)\.\w{3,4}$/
        match = File.basename(file_path).match(reg)

        info.number = match[:number].to_i
        info.title = match[:title]
      else
        tag = ref.tag

        info.number = tag.track
        info.title = tag.title
        info.album = tag.album
        info.artist = tag.artist
        info.year = tag.year
        info.genre = tag.genre
      end
    end

    info
  end
end
