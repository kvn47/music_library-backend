# frozen_string_literal: true

require 'taglib'
require 'shellwords'

class Album::Import < BaseOperation
  # TODO: add contract
  # step Contract.Build(constant: Album::Contract::Import)
  # step Contract.Validate
  # failure :contract_invalid!
  step :artist!
  step :album!
  failure :album_exists!
  step :tracks!
  step :persist!

  private

  def artist!(options, params:, **)
    name = params[:artist]
    dst = MusicLibrary.config[:library_path]

    artist = Artist.find_or_initialize_by(name: name) do |a|
      a.path = File.join dst, a.name
    end

    options['artist'] = artist
    true
  end

  def album!(options, params:, artist:, **)
    title = params[:title]
    year = params[:year]
    return false if Album.exists? title: title, artist_id: artist.id
    path = File.join artist.path, [year, title].join(' - ')
    FileUtils.mkdir_p path
    cover = copy_cover params[:cover], path
    options['album'] = Album.new artist: artist, title: title, path: path, year: year, cover: cover
    true
  end

  def tracks!(_, album:, params:, **)
    params[:tracks].each do |track_params|
      track = copy_track track_params, album
      album.tracks << track
    end
    true
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
    path = File.join album.path, "#{number} - #{track.title}#{ext}"
    Rails.logger.info "Copy #{src_path} to #{path}"
    FileUtils.copy_file src_path, path
    track.path = path
    update_tags track
    track
  end

  def update_tags(track)
    TagLib::FileRef.open(track.path) do |file|
      unless file.null?
        tag = file.tag
        tag.artist = track.artist.name
        tag.album = track.album.title
        tag.year = track.album.year
        tag.title = track.title
        file.save
      end
    end
  end

  def persist!(options, album:, **)
    album.save
    options[:model] = album
  end

  def album_exists!(options, **)
    options['result.message'] = 'Album exists'
  end
end
