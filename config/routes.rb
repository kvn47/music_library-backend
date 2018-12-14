Rails.application.routes.draw do
  scope :api do
    get 'tools/collect_info', to: 'tools#collect_info'
    get 'tools/find_work_info', to: 'tools#find_work_info'
    post 'tools/organize_files', to: 'tools#organize_files'

    resources :artists, shallow: true do
      resources :albums, shallow: true do
        resources :tracks
      end
    end

    resources :tracklists do
      post :add_tracks, on: :member
      patch :remove_track, on: :member
      patch :clear, on: :member
    end

    resources :export_lists do
      post :add, on: :member
      patch :remove, on: :member
      patch :clear, on: :member
      post :export, on: :member
    end

    resources :notes
    get 'albums_import/new', to: 'albums_import#new'
    post 'albums_import', to: 'albums_import#create'
    get :settings, to: 'settings#index'
    patch :settings, to: 'settings#update'
    put :library, to: 'library#update'
    # post :import, to: 'import#create'
    # post 'import/prepare', to: 'import#prepare'
  end
end
