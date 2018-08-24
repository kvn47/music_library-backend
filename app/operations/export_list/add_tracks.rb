class ExportList::AddTracks < ATransaction
  try :find_export_list, catch: ActiveRecord::RecordNotFound
  step :collect_tracks
  step :process

  private

  def find_export_list(id:, **params)
    export_list = ExportList.find(id)
    params.merge export_list: export_list
  end

  def collect_tracks(export_list:, **params)
    tracks = Track.query(params.slice(:artist_id, :album_id, :track_id))

    if tracks.any?
      Success({export_list: export_list}.merge(tracks: tracks))
    else
      Failure :tracks_not_found
    end
  end

  def process(export_list:, tracks:)
    tracks.each do |track|
      export_list.tracks << track
    end

    export_list.update_size
    Success export_list
  end
end
