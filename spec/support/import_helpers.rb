module ImportHelpers
  def import_source
    Rails.root.join 'tmp', 'import'
  end
end

RSpec.configure do |config|
  config.include ImportHelpers, :import
end
