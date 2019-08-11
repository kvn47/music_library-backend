require 'taglib'
require 'rubycue'
require 'shellwords'

class CollectInfo < ATransaction
  check :validate
  step :perform
  map :get_musicbrainz_info

  private

  def validate(path:, **)
    Dir.exist? path
  end

  def perform(input)
    source_infos = []
    path = input[:path]
    Dir.chdir path
    images = find_images(path)
    cover = suggested_cover(images)

    Dir['**/*.cue'].each do |cue_file|
      file = Dir["#{cue_file.gsub('cue', '')}{flac,ape}"][0]
      next if file.nil?

      cue_sheet = RubyCue::Cuesheet.new(File.read(cue_file))
      cue_sheet.parse!
      tracks = track_infos_from_cue(cue_sheet)
                 .map { |track| {number: track.number, title: track.title, cue_track: track.number} }

      source_infos << {
        cue: cue_file,
        file: file,
        images: images,
        albums: [
          {
            artist: cue_sheet.performer,
            album_artist: nil,
            title: cue_sheet.title,
            year: cue_sheet.date,
            genre: cue_sheet.genre,
            cover: cover,
            tracks: tracks
          }
        ]
      }
    end

    if source_infos.empty?
      albums = {}

      Dir['**/*.{flac,ape,dsf,mp3}'].each do |file|
        file_path = File.join(path, file)
        track_info = GetTrackInfo.(file_path)

        album_track = {number: track_info.number, title: track_info.title, file: track_info.path}

        if albums.key?(track_info.album)
          albums[track_info.album][:tracks] << album_track
        else
          album = {
            title: track_info.album,
            artist: track_info.artist,
            album_artist: nil,
            genre: track_info.genre,
            year: track_info.year,
            cover: cover,
            tracks: [album_track]
          }

          albums.store(album[:title], album)
        end
      end

      albums.values.each do |album|
        album[:tracks].sort_by! { |track| track[:number] }
      end

      source_infos << {
        images: images,
        albums: albums.values
      }
    end

    return Failure(:info_not_found) if source_infos.empty?
    Success(collect_mb_info: input[:collect_mb_info],
            source_infos: source_infos,
            search_artist: input[:artist],
            search_album: input[:album])
  end

  def get_musicbrainz_info(collect_mb_info:, source_infos:, search_artist: nil, search_album: nil)
    return source_infos unless collect_mb_info

    mb_client = MusicBrainzClient.new

    source_infos.each do |info|
      new_albums = []

      info[:albums].each do |album|
        release = mb_client.release(artist: search_artist || album[:artist], title: search_album || album[:title])

        if release.nil?
          Rails.logger.warn "[WARNING] Release not found: #{album[:artist]} - #{album[:title]}"
          next
        end

        info[:mb_release] = release[:title]
        info[:mb_release_url] = release[:url]

        release[:works].each do |work|
          new_album = album.slice(:artist, :album_artist, :title, :genre, :year, :cover)
          mb_artists = work.artists.map { |artist| artist[:name].split(',')[0] }.join(', ')

          new_album.merge! mb_title: work.title,
                           mb_date: work.composer&.end,
                           mb_id: work.id,
                           mb_url: work.url,
                           mb_composer: work.composer.name,
                           mb_composer_id: work.composer.id,
                           mb_composer_url: work.composer.url,
                           mb_artists: mb_artists

          tracks = work.parts.map do |work_part|
            track_index = album[:tracks].index { |t| t[:number] == work_part.track_number }

            if track_index && (track = album[:tracks].delete_at(track_index))
              track.merge mb_title: work_part.title[/.* ([IVX]+\..*)/, 1],
                          number: work_part.number,
                          mb_length: work_part.track_length,
                          mb_id: work_part.id,
                          mb_url: work_part.url
            else
              Rails.logger.error "[ERROR] Track not found! Work part: #{work_part.to_h}"
              next
            end
          end

          new_album[:tracks] = tracks.compact

          new_albums << new_album
        end
      end

      info[:albums] = new_albums if new_albums.any?
    end

    source_infos
  end

  def find_images(path)
    Dir.glob('*.{jpg,jpeg,png}', base: path)
  end

  def suggested_cover(images)
    images.find do |image|
      name = File.basename(image, '.*').downcase
      name == 'cover' || name == 'front' || name == 'folder'
    end || images.first
  end

  def track_infos_from_cue(cue_sheet)
    cue_sheet.songs.map do |track|
      TrackInfo.new number: track[:track],
                    title: track[:title],
                    artist: track[:performer],
                    album: cue_sheet.title,
                    genre: cue_sheet.genre,
                    year: cue_sheet.date
    end
  end
end
