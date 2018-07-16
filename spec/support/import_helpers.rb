module ImportHelpers
  def import_source
    ENV['IMPORT_SOURCE']
  end

  def import_path(path)
    File.join import_source, path
  end
end

RSpec.configure do |config|
  config.include ImportHelpers, :import
end
