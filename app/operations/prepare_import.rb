require 'taglib'
require 'shellwords'

class PrepareImport
  include Dry::Transaction

  check :validate
  tee :split_files
  step :collect_files
  map :get_tracks_info
  map :find_cover
  step :assemble_albums

  private

  AlbumInfo = Struct.new :artist, :title, :year, :cover, :tracks
  TrackInfo = Struct.new :artist, :album, :year, :number, :title, :genre, :path

  def validate(path:, **)
    Dir.exist? path
  end

  def split_files(path:, **)
    Dir.chdir path

    Dir['*.{flac,ape}'].each_with_index do |file_name, i|
      # Rails.logger.debug "file_name.start_with?('track-') => #{file_name.start_with?('track-')}"
      next if file_name.match? '/ - \d+$/'
      file = File.join path, file_name
      cue_file = "#{file.chomp(File.extname(file))}.cue"
      file_prefix = "#{file_name} - #{i + 1}"
      files_pattern = 'track-*.{flac|ape}'

      # TODO: check
      Rails.logger.debug "File.exist?(cue_file) => #{File.exist?(cue_file)}"
      Rails.logger.debug "Dir[files_pattern] => #{Dir[files_pattern]}"
      Rails.logger.debug "Dir[files_pattern].none? => #{Dir[files_pattern].none?}"
      if File.exist?(cue_file) && Dir[files_pattern].none?
        # Splitting tracks
        `cuebreakpoints #{Shellwords.escape cue_file} | shnsplit -a #{file_prefix} -o flac #{Shellwords.escape file} -O always`

        # Creating tag metadata
        `cuetag #{Shellwords.escape cue_file} #{file_prefix}*.flac`
      end
    end
  end

  def collect_files(input)
    path = input[:path]
    Dir.chdir path
    # tracks_pattern = 'track-*.flac'

    tracks_pattern = '*.{flac,ape}'# if Dir[tracks_pattern].none?

    # files = Dir[tracks_pattern].map { |f| File.join path, f }

    files = []

    Dir[tracks_pattern].each do |f|
      file = File.join path, f
      if need_to_split? file
        files << split_file(file)
      else
        files << file
      end
    end

    if files.any?
      Success input.merge(files: files)
    else
      Failure :files_not_found
    end
  end

  def get_tracks_info(input)
    tracks = []

    input[:files].each do |file|
      info = {path: file}
      ext = File.extname file

      if ext == '.flac'
        TagLib::FLAC::File.open(file) do |ref|
          tag = ref.xiph_comment || ref.tag
          unless tag.nil?
            info[:artist] = tag.artist
            info[:album] = tag.album
            info[:year] = tag.year
            info[:number] = tag.track
            info[:title] = tag.title
            info[:genre] = tag.genre
          end
        end
      else
        TagLib::FileRef.open(input[:path]) do |ref|
          unless ref.null?
            tag = ref.tag
            info[:artist] = tag.artist
            info[:album] = tag.album
            info[:year] = tag.year
            info[:number] = tag.track
            info[:title] = tag.title
            info[:genre] = tag.genre
          end
        end
      end

      tracks << TrackInfo.new(info[:artist], info[:album], info[:year],
                              info[:number], info[:title], info[:genre], info[:path])
    end

    input.merge tracks: tracks
  end

  def find_cover(input)
    images = Dir.glob('*.{jpg,jpeg,png}', base: input[:path])
    input.store :cover, File.join(input[:path], images.first) if images.any?
    input
  end

  def assemble_albums(input)
    albums = input[:tracks].group_by(&:album).map do |album, tracks|
      track = tracks.first
      # AlbumInfo.new track.artist, album, track.year, input[:cover], tracks
      {artist: track.artist, title: album, year: track.year, cover: input[:cover], tracks: tracks.map(&:to_h)}
    end

    Success albums
  end

  private

  def split_file(file)

  end
end
