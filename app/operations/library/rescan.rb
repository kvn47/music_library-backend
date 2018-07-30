module Library
  class Rescan
    include TheOperation

    TRACK_REGEXP = /^(?<number>\d+)(. | - )(?<title>.+)\.(?<type>(flac|ape))\z/
    ALBUM_REGEXP = /^(?<year>\d+) - (?<title>.+)\z/
    IMAGE_REGEXP = /.+\.(jpg|jpeg|png)/

    def call(**)
      path = MusicLibrary.config[:library_path]
      Dir.entries(path).keep_if { |e| e[0] != '.' && File.directory?(File.join(path, e)) }.each do |entry_name|
        artist = save_artist path, entry_name
        scan_artist_folder artist
      end

      Success 'ok'
    end

    private

    def scan_artist_folder(artist)
      path = artist.path
      Dir.entries(path).keep_if { |e| e[0] != '.' && File.directory?(File.join(path, e)) }.each do |entry_name|
        album = save_album artist, entry_name
        scan_album_folder album
      end
    end

    def scan_album_folder(album)
      path = album.path
      Dir.entries(album.path).keep_if { |e| e[0] != '.' && File.file?(File.join(path, e)) }.each do |file_name|
        save_track album, file_name
      end
    end

    def save_artist(path, dir_name)
      full_path = File.join path, dir_name
      attributes = {path: full_path}
      image = find_image full_path
      attributes[:image] = image unless image.nil?
      artist = Artist.find_or_create_by name: dir_name
      artist.update attributes
      artist
    end

    def save_album(artist, dir_name)
      full_path = File.join artist.path, dir_name
      attributes = {path: full_path}
      match = ALBUM_REGEXP.match dir_name
      if match.nil?
        attributes[:title] = dir_name
      else
        attributes[:title] = match[:title]
        attributes[:year] = match[:year]
      end
      image = find_image full_path
      attributes[:cover] = image unless image.nil?
      album = Album.find_or_create_by(artist: artist, title: attributes[:title])
      album.update attributes
      album
    end

    def save_track(album, file_name)
      match = TRACK_REGEXP.match file_name
      return if match.nil?
      full_path = File.join album.path, file_name
      size = File.new(full_path).size
      track = Track.create_with(number: match[:number], size: size).find_or_create_by!(album: album, title: match[:title])
      track.update path: full_path
      track
    end

    def find_image(path)
      Dir.entries(path).each do |entry_name|
        if IMAGE_REGEXP.match? entry_name
          return File.new(File.join(path, entry_name))
        end
      end
      nil
    end
  end
end
