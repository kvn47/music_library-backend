class ExportList::RemoveTrack < ATransaction
  try :find_export_list, catch: ActiveRecord::RecordNotFound
  try :find_track, catch: ActiveRecord::RecordNotFound
  step :process!
  step :message!
  failure :error!

  private

  def find_export_list(id:, **params)
    export_list = ExportList.find(id)
    params.merge export_list: export_list
  end

  def find_track(track_id:, **params)
    track = Track.find_by id: track_id
    if track
      Success params.merge(track: track)
    else
      Failure :track_not_found
    end
  end

  def process(export_list:, track:)
    export_list.tracks.delete track
    export_list.update_size
    Success export_list
  end
end