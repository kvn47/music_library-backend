class LibraryAPI < Grape::API
  resource :library do
    desc 'Rescans library'
    post :rescan do
      run_operation Library::Rescan do |m|
        m.success { |result| present(message: result) }
        m.failure(&method(:present_error))
      end
    end

    desc 'Cleans library'
    params do
      optional :with_files, type: Boolean, default: false
    end
    delete do
      run_operation Library::Purge
    end
  end
end
