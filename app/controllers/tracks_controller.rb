class TracksController < ApplicationController
  def index
    tracks = Track.query(params)
    represent tracks
  end
end
