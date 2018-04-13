class Tracklist::RemoveTrack < BaseOperation
  step Model(Tracklist, :find_by)
  failure :record_not_found!, fail_fast: true
  step :find_track!
  failure :record_not_found!, fail_fast: true
  step :remove_track!
  step :message!
  failure :error!

  private

  def find_track!(options, params:, **)
    options['track'] = Track.find_by id: params[:track_id]
  end

  def remove_track!(model:, track:, **)
    model.tracks.delete track
  end

  def message!(options, **)
    options['result.message'] = 'Track removed'
  end

  def error!(options, **)
    options['result.message'] = 'Track not removed!!!'
  end
end
