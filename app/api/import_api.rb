class ImportAPI < Grape::API
  desc 'Imports music'
  params do
    requires :path, type: String
    requires :source_infos, type: Array do
      optional :cue, type: String
    end
  end
  post :import do
    run_operation Import::Perform
  end
end
