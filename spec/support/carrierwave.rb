CarrierWave.configure do |config|
  config.storage = :file
  config.enable_processing = false
end

RSpec.configure do |config|
  config.after :all do
    FileUtils.rm_rf Dir["#{Rails.root}/tmp/uploads/[^.]*"]
  end
end