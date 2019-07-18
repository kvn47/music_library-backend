# frozen_string_literal: true

class API < Grape::API
  format :json
  default_format :json
  helpers ActionsHelpers

  rescue_from ActiveRecord::RecordNotFound do |exception|
    present_error exception.message, status: 404
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    present_model_errors exception.record
  end

  rescue_from ActiveRecord::StatementInvalid,
              ActiveRecord::RecordNotUnique,
              ActiveRecord::RecordNotDestroyed do |exception|
    present_error exception.message
  end

  mount LibraryAPI
  mount SettingsAPI
  mount ToolsAPI
  mount ImportAPI
  mount ArtistsAPI
  mount AlbumsAPI
  mount TracksAPI
  mount TracklistsAPI
  mount ExportListsAPI
  mount NotesAPI
  mount MusicBrainzAPI
end
