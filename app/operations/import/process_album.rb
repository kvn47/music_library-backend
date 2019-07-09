require 'taglib'
require 'shellwords'

module Import
  class ProcessAlbum < ATransaction
    map :artist!
    map :album!
    map :tracks!
    step :persist

    private

    def artist!(input)
      dst = MusicLibrary.config[:library_path]
      artist_params = input[:artist]

      artist = if artist_params[:id].present?
        Artist.find artist_params[:id]
      else
        Artist.find_or_initialize_by(name: artist_params[:name]) do |a|
          a.path = File.join(dst, a.name.sub(':', ''))
          a.mb_id = artist_params[:mb_id]
        end
      end

      input.merge artist: artist
    end

    def album!(input)
      artist = input[:artist]
      album_artist = input[:album_artist]
      title = input[:title]
      title = "#{title} [#{album_artist}]" if album_artist.present?
      year = input[:year]
      album = Album.find_by(title: title, artist_id: artist.id)

      if album.nil?
        folder_name = year.nil? ? title : "#{title} (#{year})"
        path = File.join(artist.path, folder_name.sub(':', ''))
        Rails.logger.debug "FileUtils.mkdir_p(#{path})"
        FileUtils.mkdir_p path
        cover = copy_cover(input[:cover], path)
        album = Album.new(title: title, artist: artist, album_artist: album_artist, path: path, year: year, cover: cover)
      end

      result = input.merge album: album
      Rails.logger.debug "[album!] #{result}"
      result
    end

    def tracks!(input)
      album = input['album']
      album.tracks.clear

      album.tracks = input['tracks'].map do |track_params|
        track = Track.new album: album, number: track_params[:number], title: track_params[:title]
        src_path = track_params[:path]
        ext = File.extname src_path
        number = format '%02d', track.number
        title = track.title.gsub(%r{[:\/]}, '.')
        dst_path = File.join album.path, "#{number}. #{title.sub(':', '')}#{ext}"
        Rails.logger.info "Copy #{src_path} to #{dst_path}"
        FileUtils.copy_file src_path, dst_path
        track.path = dst_path
        update_tags track
        track
      end

      album
    end

    def persist(album)
      if album.save
        Success album
      else
        Failure album.errors
      end
    end

    def copy_cover(src, dst_path)
      return nil if src.nil? || !File.exist?(src)
      dst = File.join dst_path, "cover#{File.extname(src)}"
      FileUtils.copy_file src, dst
      Pathname.new(dst).open
    end

    def copy_track(track_params, album)
      track = Track.new album: album, number: track_params[:number], title: track_params[:title]
      src_path = track_params[:path]
      ext = File.extname src_path
      number = format '%02d', track.number
      title = track.title.gsub(%r{[:\/]}, '.')
      dst_path = File.join album.path, "#{number}. #{title.sub(':', '')}#{ext}"
      Rails.logger.info "Copy #{src_path} to #{dst_path}"
      FileUtils.copy_file src_path, dst_path
      track.path = dst_path
      update_tags track
      track
    end

    def update_tags(track)
      TagLib::FileRef.open(track.path) do |file|
        unless file.null?
          tag = file.tag
          tag.artist = track.artist.name
          tag.album = track.album.title
          tag.year = track.album.year unless track.album.year.nil?
          tag.title = track.title
          file.save
        end
      end
    end

  end
end
