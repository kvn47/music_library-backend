require 'taglib'

class ScanLibrary < AnOperation
  TRACK_FORMATS = 'flac,dsf,ogg,opus,mp3'

  def call
    path = MusicLibrary.config[:library_path]

    Dir.entries(path).keep_if { |e| e[0] != '.' && File.directory?(File.join(path, e)) }.each do |artist_dir|
      artist_path = File.join(path, artist_dir)
      artist_image = find_image(artist_path)
      artist = nil

      Dir.entries(artist_path).keep_if { |e| e[0] != '.' && File.directory?(File.join(artist_path, e)) }.each do |album_dir|
        album_path = File.join(artist_path, album_dir)
        album_cover = find_image(album_path)
        album = nil

        Dir.glob("*.{#{TRACK_FORMATS}}", base: album_path).keep_if { |e| e[0] != '.' }.each do |file_name|
          track_path = File.join(album_path, file_name)
          track_info = GetTrackInfo.(track_path)
          track_info.artist ||= artist_dir
          track_info.album ||= album_dir
          artist ||= Artist.create(name: track_info.artist, image: artist_image, path: artist_path)
          album ||= Album.create(artist: artist, title: track_info.album, year: track_info.year,
                                 cover: album_cover, path: album_path)
          size = File.new(track_path).size

          Track.create number: track_info.number, title: track_info.title, size: size, album: album, path: track_path
        end
      end
    end

    Success "Artists: #{Artist.count}. Albums: #{Album.count}. Tracks: #{Track.count}"
  end

  private

  def find_image(path)
    Dir.glob('*.{jpg,jpeg,png}', base: path)[0]
  end
end
