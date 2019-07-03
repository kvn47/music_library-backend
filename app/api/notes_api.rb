class NotesAPI < Grape::API
  namespace_inheritable :model_class, Note

  helpers do
    params :note_params do
      optional :kind, type: String, values: Note::KINDS, default: Note::KINDS.first
      optional :details, type: String
      optional :artist, type: String
      optional :album, type: String
      optional :download_url, type: String
      optional :download_path, type: String
      optional :release_date, type: Date
    end
  end

  resource :notes do
    desc 'Creates note'
    params do
      use :note_params
    end
    post do
      base_create_action
    end

    desc 'Returns released notes'
    params do
      optional :search, type: String
    end
    get do
      notes = Note.released
      present_model notes
    end

    route_param :kind, type: String, values: Note::KINDS do
      desc 'Returns notes of kind'
      params do
        optional :search, type: String
      end
      get do
        base_index_action
      end
    end

    route_param :id, type: Integer do
      desc 'Returns note'
      get do
        base_show_action
      end

      desc 'Updates note'
      params do
        use :note_params
      end
      put do
        base_update_action
      end

      desc 'Deletes note'
      delete do
        base_delete_action
      end
    end
  end
end
