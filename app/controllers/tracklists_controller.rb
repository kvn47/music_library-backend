class TracklistsController < BaseController
  def add_tracks
    run Tracklist::AddTracks do |r|
      r.success { |tracklist| represent tracklist }
      r.failure { |error| render_error error }
    end
  end

  def remove_track
    run Tracklist::RemoveTrack do |r|
      r.success { |tracklist| represent tracklist }
      r.failure { |error| render_error error }
    end
  end

  def clear
    run Tracklist::Clear do |r|
      r.success { |tracklist| represent tracklist }
      r.failure { |error| render_error error }
    end
  end
end
