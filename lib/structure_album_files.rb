require 'taglib'
require 'rubycue'
require 'fileutils'
require 'shellwords'

class StructureAlbumFiles
  def self.call(path)
    new.(path)
  end

  def call(path)
    parent_path = File.expand_path('..', path)
    albums = collect_albums path

    if albums.any?
      albums.each do |cue_sheet:, cue_file_path:, music_file_path:|
        album_path = File.join(parent_path, cue_sheet.performer, cue_sheet.title)
        FileUtils.mkdir_p album_path
        FileUtils.cd album_path
        split_file music_file_path, cue_file_path
        copy_cover path, album_path
      end
    else
      music_files = Dir.glob('**/*.{flac,ape,mp3}', base: path)
      music_file_path = File.join(path, music_files.first)
      tag = get_tag(music_file_path)
      album_path = File.join(parent_path, tag.artist, "#{tag.year} - #{tag.album}")
      FileUtils.mkdir_p album_path
      copy_music_files music_files, path, album_path
      copy_cover path, album_path
    end

    0
  end

  private

  TrackInfo = Struct.new :artist, :album, :year, :number, :title, :genre, :file

  def collect_albums(path)
    albums = []

    Dir.glob('**/*.cue', base: path).each do |cue_file_name|
      cue_file_path = File.join(path, cue_file_name)
      cue_sheet = RubyCue::Cuesheet.new(File.read(cue_file_path))
      cue_sheet.parse!
      next if cue_sheet.file.nil?
      music_file_path = File.join(path, cue_sheet.file)
      next unless File.exist?(music_file_path)
      albums << {cue_sheet: cue_sheet, cue_file_path: cue_file_path, music_file_path: music_file_path}
    end

    albums
  end

  def split_file(file, cue)
    cue = Shellwords.escape(cue)
    file = Shellwords.escape(file)
    `shnsplit -f #{cue} -t '%n. %t' -o flac -O always #{file}`

    # Creating tag metadata
    # `cuetag #{cue_file} #{prefix}*.flac`
  end

  def copy_music_files(files, src, dst)
    FileUtils.cd src

    files.each do |file|
      file_path = File.join src, file
      tag = get_tag file_path
      dst_file_name = "#{tag.number}. #{tag.title}#{File.extname(file)}"
      FileUtils.copy_file file_path, File.join(dst, dst_file_name)
    end
  end

  def copy_cover(src, dst)
    images = Dir.glob('*.{jpg,jpeg,png}', base: src)
    FileUtils.cp(File.join(src, images.first), dst) if images.any?
  end

  def get_tag(file_path)
    if File.extname(file_path) == '.flac'
      TagLib::FLAC::File.open(file_path) do |file|
        tag = file.xiph_comment
        unless tag.nil?
          TrackInfo.new tag.artist, tag.album, tag.year, tag.track, tag.title, tag.genre, file
        end
      end
    else
      TagLib::FileRef.open(file_path) do |ref|
        unless ref.null?
          tag = ref.tag
          TrackInfo.new tag.artist, tag.album, tag.year, tag.track, tag.title, tag.genre, file
        end
      end
    end
  end
end
