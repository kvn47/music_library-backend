require 'taglib'
require 'rubycue'
require 'shellwords'

module Import
  class CollectInfo < ATransaction
    check :validate
    step :perform
    tee :get_musicbrainz_info

    private

    AlbumInfo = Struct.new :artist, :title, :year, :cover, :tracks
    TrackInfo = Struct.new :artist, :album, :year, :number, :title, :genre, :file

    def validate(path:, **)
      Dir.exist? path
    end

    def perform(input)
      import_info = []
      path = input[:path]
      Dir.chdir path

      Dir['**/*.cue'].each do |cue_file|
        cue_sheet = RubyCue::Cuesheet.new(File.read(cue_file))
        cue_sheet.parse!
        next unless cue_sheet.file.present? && File.exist?(cue_sheet.file)
        tracks = track_infos_from_cue(cue_sheet)

        import_info << {
          cue: cue_file,
          file: cue_sheet.file,
          albums: [
            {
              artist: cue_sheet.performer,
              title: cue_sheet.title,
              genre: cue_sheet.genre,
              cover: find_cover(path),
              tracks: tracks.map { |track| {number: track.number, title: track.title, cue_track: track.number} }
            }
          ]
        }
      end

      if import_info.empty?
        tracks = []

        Dir['**/*.{flac,ape,mp3}'].each do |file|
          ext = File.extname file
          track_info = ext == '.flac' ? track_info_from_flac(file) : track_info_from_basic(file)
          tracks << track_info
        end

        import_info << {
          albums: [
            {
              artist: tracks.first.artist,
              title: tracks.first.album,
              genre: tracks.first.genre,
              year: tracks.first.year,
              cover: find_cover(path),
              tracks: tracks.map { |track| {number: track.number, title: track.title, file: track.file} }
            }
          ]
        }
      end

      return Failure :info_not_found if import_info.empty?
      Success import_info
    end

    def get_musicbrainz_info(import_info)
      mb_client = MusicBrainzClient.new

      import_info[:albums].each do |album|
        mb_info = mb_client.search_release(artist: album[:artist], title: album[:title])
        album[:mb_info] = mb_info
      end
    end

    def find_cover(path)
      images = Dir.glob('*.{jpg,jpeg,png}', base: path)
      images.first if images.any?
    end

    def track_infos_from_cue(cue_sheet)
      cue_sheet.songs.map do |track|
        TrackInfo.new track[:performer], cue_sheet.title, nil, track[:track],
                      track[:title], cue_sheet.genre
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
end
