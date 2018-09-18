class TracksController < BaseController
  def index
    tracks = Track.query(**action_params)
    represent tracks
  end
end
