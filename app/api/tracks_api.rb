class TracksAPI < Grape::API
  namespace_inheritable :model_class, Track

  helpers do
    params :track_params do
      requires :title, type: String
      requires :number, type: Integer
      requires :album_id, type: Integer
    end
  end

  resource :tracks do
    desc 'Creates track'
    params do
      use :track_params
    end
    post do
      base_create_action
    end

    desc 'Returns tracks'
    params do
      optional :album_id, type: Integer
      optional :search, type: String
    end
    get do
      tracks = Track.includes(album: :artist).query(**declared_params)
      present_model tracks
    end

    route_param :id, type: Integer do
      desc 'Returns track'
      get do
        base_show_action
      end

      desc 'Updates track'
      params do
        use :track_params
      end
      patch do
        base_update_action
      end

      desc 'Deletes track'
      delete do
        base_delete_action
      end
    end
  end
end
