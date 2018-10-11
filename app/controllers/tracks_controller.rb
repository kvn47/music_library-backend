class TracksController < ApplicationController
  include BaseCreateAction
  include BaseShowAction
  include BaseUpdateAction
  include BaseDestroyAction

  def index
    tracks = Track.includes(album: :artist).query(**action_params)
    represent tracks
  end
end
