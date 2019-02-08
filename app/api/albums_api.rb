class AlbumsAPI < Grape::API
  namespace_inheritable :model_class, Album

  helpers do
    params :album_params do
      requires :title, type: String
      requires :artist_id, type: Integer
    end
  end

  resource :albums do
    desc 'Creates album'
    params do
      use :album_params
    end
    post do
      base_create_action
    end

    desc 'Returns albums'
    params do
      requires :artist_id, type: Integer
      optional :search, type: String
    end
    get do
      base_index_action
    end

    route_param :id, type: Integer do
      desc 'Returns album'
      get do
        base_show_action
      end

      desc 'Updates album'
      params do
        use :album_params
      end
      patch do
        base_update_action
      end

      desc 'Deletes album'
      delete do
        base_delete_action
      end
    end
  end
end
