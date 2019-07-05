require 'taglib'
require 'rubycue'
require 'shellwords'

class CollectInfo < ATransaction
  check :validate
  step :perform
  map :get_musicbrainz_info

  private

  AlbumInfo = Struct.new :artist, :title, :year, :cover, :tracks
  TrackInfo = Struct.new :artist, :album, :year, :number, :title, :genre, :file

  def validate(path:, **)
    Dir.exist? path
  end

  def perform(input)
    source_infos = []
    path = input[:path]
    Dir.chdir path

    Dir['**/*.cue'].each do |cue_file|
      file = Dir["#{cue_file.gsub('cue', '')}{flac,ape}"][0]
      next if file.nil?

      cue_sheet = RubyCue::Cuesheet.new(File.read(cue_file))
      cue_sheet.parse!
      tracks = track_infos_from_cue(cue_sheet)

      source_infos << {
        cue: cue_file,
        file: file,
        images: find_images(path),
        albums: [
          {
            artist: cue_sheet.performer,
            album_artist: nil,
            title: cue_sheet.title,
            year: cue_sheet.date,
            genre: cue_sheet.genre,
            cover: nil,
            tracks: tracks.map { |track| {number: track.number, title: track.title, cue_track: track.number} }
          }
        ]
      }
    end

    if source_infos.empty?
      albums = {}

      Dir['**/*.{flac,ape,mp3}'].each do |file|
        track_info = get_track_info(file)

        album_track = {number: track_info.number, title: track_info.title, file: track_info.file}

        if albums.key?(track_info.album)
          albums[track_info.album][:tracks] << album_track
        else
          album = {
            title: track_info.album,
            artist: track_info.artist,
            album_artist: nil,
            genre: track_info.genre,
            year: track_info.year,
            cover: nil,
            tracks: [album_track]
          }

          albums.store(album[:title], album)
        end
      end

      source_infos << {
        images: find_images(path),
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
            track = album[:tracks].delete_at(track_index) if track_index

            if track
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

  def track_infos_from_cue(cue_sheet)
    cue_sheet.songs.map do |track|
      TrackInfo.new track[:performer], cue_sheet.title, nil, track[:track],
                    track[:title], cue_sheet.genre
    end
  end

  def get_track_info(file)
    # ext = File.extname file
    # track_info = ext == '.flac' ? track_info_from_flac(file) : track_info_from_basic(file)

    TagLib::FileRef.open(file) do |ref|
      unless ref.null?
        tag = ref.tag
        TrackInfo.new tag.artist, tag.album, tag.year, tag.track, tag.title, tag.genre, file
      end
    end
  end

  def track_info_from_flac(file)
    TagLib::FLAC::File.open(file) do |ref|
      tag = ref.xiph_comment || ref.tag
      unless tag.nil?
        TrackInfo.new tag.artist, tag.album, tag.year, tag.track, tag.title, tag.genre, file
      end
    end
  end

  def track_info_from_basic(file)
    TagLib::FileRef.open(file) do |ref|
      unless ref.null?
        tag = ref.tag
        TrackInfo.new tag.artist, tag.album, tag.year, tag.track, tag.title, tag.genre, file
      end
    end
  end
end
