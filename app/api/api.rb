# frozen_string_literal: true

class API < Grape::API
  format :json
  default_format :json
  helpers ActionsHelpers

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
