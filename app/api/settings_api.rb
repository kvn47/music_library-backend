class SettingsAPI < Grape::API
  desc 'Get settings'
  get 'settings' do
    present MusicLibrary.config
  end

  desc 'Update settings'
  params do
    optional :library_path, type: String
  end
  patch 'settings' do
    run_operation UpdateSettings do |m|
      m.success(&method(:present))
      m.failure(&method(:present_error))
    end
  end
end
