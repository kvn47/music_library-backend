require 'taglib'
require 'rubycue'
require 'shellwords'

class PrepareImport
  include Dry::Transaction

  check :validate
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

  def collect_files(input)
    files = []
    path = input[:path]
    Dir.chdir path
    cue_files = Dir['*.cue']

    if cue_files.any?
      cue_files.each do |cue_file|
        file_name = File.basename(cue_file, '.*')
        prefix = "#{file_name} - "
        split_pattern = "#{prefix}*.flac"
        split_file(cue_file, prefix) if Dir[split_pattern].empty?
        files += Dir[split_pattern]
      end
    else
      ape_files = Dir['*.ape']
      convert_ape ape_files if ape_files.any?
      files += Dir['*.flac']
    end

    if files.any?
      Success input.merge(files: files)
    else
      Failure :files_not_found
    end
  end

  def get_tracks_info(input)
    path = input[:path]
    tracks = []

    input[:files].each do |file_name|
      file_path = File.join path, file_name
      info = {path: file_name}
      ext = File.extname file_name

      if ext == '.flac'
        TagLib::FLAC::File.open(file_path) do |ref|
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
        TagLib::FileRef.open(file_path) do |ref|
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
      {artist: track.artist, title: album, year: track.year, cover: input[:cover], tracks: tracks.map(&:to_h)}
    end

    Success albums
  end

  def split_file(cue_file, prefix)
    cuesheet = RubyCue::Cuesheet.new(File.read(cue_file))
    cuesheet.parse!
    file_name = Shellwords.escape(cuesheet.file)
    cue_file = Shellwords.escape(cue_file)
    prefix = Shellwords.escape(prefix)

    `shnsplit -f #{cue_file} -a #{prefix} -o flac -O always #{file_name}`
    # `cuebreakpoints #{cue_file} | shnsplit -f #{cue_file} -a #{prefix} -o flac -O always #{file_name}`

    # Creating tag metadata
    `cuetag #{cue_file} #{prefix}*.flac`
  end

  def convert_ape(files)
    files.each do |file|
      `shnconv -o flac -O always #{Shellwords.escape(file)}`
    end
  end
end
