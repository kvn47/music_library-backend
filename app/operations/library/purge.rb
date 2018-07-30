module Library
  class Purge
    include TheOperation

    def call(with_files: false)
      [Tracklist, ExportList, Artist].each(&:destroy_all)

      if with_files
        FileUtils.rmtree MusicLibrary.config[:library_path]
      end
    end
  end
end
