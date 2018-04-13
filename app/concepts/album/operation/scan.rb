require 'taglib'
require 'shellwords'
# TODO: split on steps
# TODO: do not split tracks if there is splitted tracks 'track-'
class Album::Scan < BaseOperation
  AlbumInfo = Struct.new :artist, :title, :year, :cover, :tracks

  step :get_info

  def get_info(options, params:, **)
    path = params[:path]
    Dir.chdir path
    files = get_files path
    tracks = files.map { |file| get_track_data file }
    cover = find_images(path).first
    options[:model] = AlbumInfo.new tracks.first[:artist], tracks.first[:album], tracks.first[:year], cover, tracks
  end

  def find_images(path)
    pattern = File.join path, '*.{jpg,jpeg,png}'
    images = Dir[pattern]
  end

  def get_files(path)
    Dir.chdir path
    files = []
    Dir['*.{flac,ape}'].each_with_index do |f, i|
      file = File.join path, f
      cue_file = "#{file.chomp(File.extname(file))}.cue"
      if File.exists?(cue_file)
        file_prefix = "track-#{i + 1}"

        # Splitting tracks
        `cuebreakpoints #{Shellwords.escape cue_file} | shnsplit -a #{file_prefix} -o flac #{Shellwords.escape file} -O always`

        # Creating tag metadata
        `cuetag #{Shellwords.escape cue_file} #{file_prefix}*.flac`

        files += Dir["#{file_prefix}*.flac"].map { |f| File.join path, f }
      else
        files << file
      end
    end
    files
  end

  def get_track_data(path)
    data = {checked: true, path: path}
    ext = File.extname path
    if ext == '.flac'
      TagLib::FLAC::File.open(path) do |file|
        tag = file.xiph_comment || file.tag
        unless tag.nil?
          data[:artist] = tag.artist
          data[:album] = tag.album
          data[:year] = tag.year
          data[:number] = tag.track
          data[:title] = tag.title
          data[:genre] = tag.genre
          data[:path] = path
        end
      end
    else
      TagLib::FileRef.open(path) do |ref|
        unless ref.null?
          tag = ref.tag
          data[:artist] = tag.artist
          data[:album] = tag.album
          data[:year] = tag.year
          data[:number] = tag.track
          data[:title] = tag.title
          data[:genre] = tag.genre
        end
      end
    end
    data
  end
end