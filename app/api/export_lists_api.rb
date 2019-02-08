class ExportListsAPI < Grape::API
  namespace_inheritable :model_class, ExportList

  helpers do
    params :export_list_params do
      requires :name, type: String
      optional :capacity, type: Integer
      optional :destination_path, type: String
    end
  end

  resource :export_lists do
    desc 'Creates export_list'
    params do
      use :export_list_params
    end
    post do
      base_create_action
    end

    desc 'Returns export_lists'
    params do
      optional :search, type: String
    end
    get do
      base_index_action
    end

    route_param :id, type: Integer do
      desc 'Returns export_list'
      get do
        base_show_action
      end

      desc 'Updates export_list'
      params do
        use :export_list_params
      end
      patch do
        base_update_action
      end

      desc 'Deletes export_list'
      delete do
        base_delete_action
      end

      desc 'Adds tracks to export_list'
      post :add_tracks do
        run_operation ExportList::AddTracks
      end

      desc 'Removes track from export_list'
      put :remove_track do
        run_operation ExportList::RemoveTrack
      end

      desc 'Clears export_list'
      put :clear do
        run_operation ExportList::Clear
      end

      desc 'Performs export'
      post :export do
        run_operation ExportList::Export
      end
    end
  end
end
