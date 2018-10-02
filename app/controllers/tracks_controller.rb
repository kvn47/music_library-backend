class TracksController < BaseController
  def index
    tracks = Track.includes(album: :artist).query(**action_params)
    represent tracks
  end
end
