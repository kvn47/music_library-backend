class Tracklist::AddTracks < ATransaction
  step :find_tracklist
  step :collect_tracks
  step :process

  private

  def find_tracklist(id:, **params)
    FindRecord.new.(model_class: Tracklist, id: id, **params)
  end

  def collect_tracks(tracklist:, **params)
    tracks = Track.query(params.slice(:artist_id, :album_id, :track_id))

    if tracks.any?
      Success({tracklist: tracklist}.merge(tracks: tracks))
    else
      Failure :tracks_not_found
    end
  end

  def process(tracklist:, tracks:)
    tracks.each do |track|
      tracklist.tracks << track
    end

    Success tracklist
  end
end
