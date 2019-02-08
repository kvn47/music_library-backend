class TracklistsAPI < Grape::API
  namespace_inheritable :model_class, Tracklist

  helpers do
    params :tracklist_params do
      requires :name, type: String
    end
  end

  resource :tracklists do
    desc 'Creates tracklist'
    params do
      use :tracklist_params
    end
    post do
      base_create_action
    end

    desc 'Returns tracklists'
    params do
      optional :search, type: String
    end
    get do
      base_index_action
    end

    route_param :id, type: Integer do
      desc 'Returns tracklist'
      get do
        base_show_action
      end

      desc 'Updates tracklist'
      params do
        use :tracklist_params
      end
      patch do
        base_update_action
      end

      desc 'Deletes tracklist'
      delete do
        base_delete_action
      end

      desc 'Adds tracks to tracklist'
      post :add_tracks do
        run_operation Tracklist::AddTracks
      end

      desc 'Removes track from tracklist'
      put :remove_track do
        run_operation Tracklist::RemoveTrack
      end

      desc 'Clears tracklist'
      put :clear do
        run_operation Tracklist::Clear
      end
    end
  end
end
