class LibraryAPI < Grape::API
  resource :library do
    desc 'Scans library'
    post :scan do
      ScanLibrary.call do |m|
        m.success { |result| present(message: result) }
        m.failure(&method(:present_error))
      end
    end

    desc 'Purges library'
    params do
      optional :with_files, type: Boolean, default: false
    end
    delete do
      run_operation PurgeLibrary
    end
  end
end
