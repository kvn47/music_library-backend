class ArtistsAPI < Grape::API
  namespace_inheritable :model_class, Artist

  helpers do
    params :artist_params do
      requires :name, type: String
    end
  end

  resource :artists do
    desc 'Creates artist'
    params do
      use :artist_params
    end
    post do
      base_create_action
    end

    desc 'Returns artists'
    params do
      optional :search, type: String
    end
    get do
      base_index_action
    end

    route_param :id, type: Integer do
      desc 'Returns artist'
      get do
        base_show_action
      end

      desc 'Updates artist'
      params do
        use :artist_params
      end
      patch do
        base_update_action
      end

      desc 'Deletes artist'
      delete do
        base_delete_action
      end
    end
  end
end
