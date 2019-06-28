# require 'taglib'
require 'fileutils'
require 'shellwords'

class OrganizeAlbumFiles < ATransaction
  tee :process

  private

  def process(path:, source_infos:, dst_path: nil, copy_files:, **)
    dst_path = File.expand_path('..', path) if dst_path.blank?
    FileUtils.cd path

    source_infos.each do |source_info|
      cue = source_info['cue']
      file = source_info['file']
      albums = source_info['albums']

      if cue.present?
        prefix = "#{File.basename(file, '.*')} - "
        split_file(file, cue, prefix)

        albums.each do |album|
          album_path = make_album_path(album, dst_path)

          album['tracks'].each do |track|
            file_name = "#{prefix + format('%02d', track['cue_track'])}.flac"

            if File.exists?(file_name)
              write_tags(file_name, track, album)
              dst_file_name = "#{format('%02d', track['number'])}. #{track['title']}.flac"
              dst_file_path = File.join(album_path, dst_file_name)
              FileUtils.move(file_name, dst_file_path)
            else
              Rails.logger.error("[ERROR] File not found: #{file_name}")
            end
          end

          FileUtils.cp(album['cover'], album_path) if album['cover'].present?
        end
      else
        albums.each do |album|
          album_path = make_album_path(album, dst_path)

          album['tracks'].each do |track|
            write_tags(track['file'], track, album)
            dst_file_path = File.join(album_path, "#{track['number']}. #{track['title']}#{File.extname(track['file'])}")

            if copy_files == 'true'
              FileUtils.copy_file(track['file'], dst_file_path)
            else
              FileUtils.move(track['file'], dst_file_path)
            end
          end

          FileUtils.cp(album['cover'], album_path) if album['cover'].present?
        end
      end
    end
  end

  def make_album_path(album, dst_path)
    album['title'] = "#{album['title']} [#{album['album_artist']}]" if album['album_artist'].present?
    album_dir_name = album['year'].present? ? "#{album['title']} (#{album['year']})" : album['title']
    album_path = File.join(dst_path, album['artist'], album_dir_name)
    FileUtils.mkdir_p(album_path)
    album_path
  end

  def split_file(file, cue, prefix)
    cue = Shellwords.escape(cue)
    file = Shellwords.escape(file)
    prefix = Shellwords.escape(prefix)
    `shnsplit -f #{cue} -a #{prefix} -o flac -O always #{file}`
  end

  def write_tags(file_name, track, album)
    TagLib::FileRef.open(file_name) do |file|
      unless file.null?
        file.tag.tap do |tag|
          tag.artist = album['artist']
          tag.album = album['title']
          tag.year = album['year'].to_i
          tag.title = track['title']
          tag.genre = album['genre']
          tag.track = track['number']
        end

        file.save
      end
    end
  end
end
