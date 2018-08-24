class Tracklist::RemoveTrack < BaseOperation
  step :find_tracklist
  step :process

  private

  def find_tracklist(id:, **params)
    FindRecord.new.(model_class: Tracklist, id: id, **params)
  end

  def find_track(track_id:, **params)
    track = Track.find_by id: track_id
    if track
      Success params.merge(track: track)
    else
      Failure :track_not_found
    end
  end

  def process(tracklist:, track:)
    tracklist.tracks.delete track
    Success tracklist
  end
end
