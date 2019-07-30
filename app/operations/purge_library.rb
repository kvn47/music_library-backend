class PurgeLibrary < AnOperation
  def call(with_files: false)
    [Tracklist, ExportList, Artist].each(&:destroy_all)

    if with_files
      FileUtils.rm_rf Dir.glob("#{MusicLibrary.config[:library_path]}/*")
    end
  end
end
