class ImportAPI < Grape::API
  desc 'Imports music'
  params do
    requires :path, type: String
    requires :source_infos, type: Array do
      optional :cue, type: String
      optional :file, type: String
      requires :albums, type: Array do
        requires :artist, type: Hash do
          optional :id, type: Integer
          optional :name, type: String
          optional :mb_id, type: String
          at_least_one_of :id, :name
        end
        requires :title, type: String
        optional :album_artist, type: String
        optional :genre, type: String
        optional :year, type: Integer
        optional :mb_id, type: String
        requires :tracks, type: Array do
          requires :title, type: String
          requires :number, type: Integer
          optional :cue_track, type: Integer
          optional :file, type: String
          optional :mb_id, type: String
        end
      end
    end
  end
  post :import do
    Import::Perform.(params) do |r|
      r.success(&method(:present_model))
      r.failure(&method(:present_error))
    end
  end
end
