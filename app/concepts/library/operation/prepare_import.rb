require 'taglib'
require 'shellwords'

class Library::PrepareImport < BaseOperation
  # TODO: add contract

  step :split_files
  step :get_files
  # step :prepare_files
  step :get_tracks_info
  step :find_cover
  step :set_albums

  private

  AlbumInfo = Struct.new :artist, :title, :year, :cover, :tracks
  TrackInfo = Struct.new :artist, :album, :year, :number, :title, :genre, :path

  def split_files(options, params:, **)
    path = params[:path]
    Dir.chdir path

    Dir['*.{flac,ape}'].each_with_index do |file_name, i|
      file = File.join path, file_name
      cue_file = "#{file.chomp(File.extname(file))}.cue"
      file_prefix = "track-#{i + 1}"
      files_pattern = "#{file_prefix}*.flac"

      if File.exist?(cue_file) && Dir[files_pattern].none?
        # Splitting tracks
        `cuebreakpoints #{Shellwords.escape cue_file} | shnsplit -a #{file_prefix} -o flac #{Shellwords.escape file} -O always`

        # Creating tag metadata
        `cuetag #{Shellwords.escape cue_file} #{file_prefix}*.flac`
      end
    end
  end

  def get_files(options, params:, **)
    path = params[:path]
    Dir.chdir path
    files_pattern = 'track-*.flac'

    files_pattern = '*.{flac,ape}' if Dir[files_pattern].none?

    files = Dir[files_pattern].map { |f| File.join path, f }
    options['files'] = files
    true
  end

  def get_tracks_info(options, params:, files:, **)
    tracks = []
    path = params[:path]

    files.each do |file|
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
            # info[:path] = path
          end
        end
      else
        TagLib::FileRef.open(path) do |ref|
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

    options['tracks'] = tracks
    true
  end

  def find_cover(options, params:, **)
    pattern = File.join params[:path], '*.{jpg,jpeg,png}'
    images = Dir[pattern]
    options['cover'] = images.first
    true
  end

  def set_albums(options, tracks:, cover:, **)
    albums = []
    tracks.group_by(&:album).each do |album, tracks|
      track = tracks.first
      albums << AlbumInfo.new(track.artist, album, track.year, cover, tracks)
    end
    options[:model] = albums
    true
  end
end
