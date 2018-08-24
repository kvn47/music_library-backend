module ImportHelpers
  def import_source
    ENV['IMPORT_SOURCE']
  end

  def library_path
    ENV['MUSIC_LIBRARY']
  end

  def import_path(path)
    File.join import_source, path
  end
end

RSpec.configure do |config|
  config.include ImportHelpers, :import
end
