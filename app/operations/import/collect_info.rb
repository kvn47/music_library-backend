require 'taglib'
require 'rubycue'
require 'shellwords'

module Import
  class CollectInfo
    include Dry::Transaction

    check :validate
    step :collect_tracks
    map :find_cover
    step :assemble_albums

    private

    AlbumInfo = Struct.new :artist, :title, :year, :cover, :tracks
    TrackInfo = Struct.new :artist, :album, :year, :number, :title, :genre, :path

    def validate(path:, **)
      Dir.exist? path
    end

    def collect_tracks(input)
      tracks = []
      path = input[:path]
      Dir.chdir path

      Dir['**/*.cue'].each do |cue_file|
        cue_sheet = RubyCue::Cuesheet.new(File.read(cue_file))
        cue_sheet.parse!
        next unless cue_sheet.file.present? && File.exist?(cue_sheet.file)
        tracks += track_infos_from_cue(cue_sheet, path)
      end

      if tracks.empty?
        Dir['**/*.{flac,ape,mp3}'].each do |file|
          ext = File.extname file
          track_info = ext == '.flac' ? track_info_from_flac(file) : track_info_from_basic(file)
          track_info.path = File.join(path, file)
          tracks << track_info
        end
      end

      return Failure :tracks_not_found if tracks.empty?
      Success input.merge(tracks: tracks)
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

    def track_infos_from_cue(cue_sheet, path)
      track_path = File.join(path, cue_sheet.file)

      cue_sheet.songs.map do |track|
        TrackInfo.new track[:performer], cue_sheet.title, nil, track[:track],
                      track[:title], cue_sheet.genre, track_path
      end
    end

    def track_info_from_flac(file)
      TagLib::FLAC::File.open(file) do |ref|
        tag = ref.xiph_comment || ref.tag
        unless tag.nil?
          TrackInfo.new tag.artist, tag.album, tag.year, tag.track, tag.title, tag.genre
        end
      end
    end

    def track_info_from_basic(file)
      TagLib::FileRef.open(file) do |ref|
        unless ref.null?
          tag = ref.tag
          TrackInfo.new tag.artist, tag.album, tag.year, tag.track, tag.title, tag.genre
        end
      end
    end
  end
end
