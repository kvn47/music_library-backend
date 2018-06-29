class ExportList::Remove < BaseOperation
  step Model(ExportList, :find_by)
  failure :record_not_found!, fail_fast: true
  step :track!
  failure :record_not_found!, fail_fast: true
  step :process!
  step :message!
  failure :error!

  def process!(_, model:, track:, **)
    model.tracks.delete track
    model.update_size
  end

  def track!(options, params:, **)
    options['track'] = Track.find_by id: params[:track_id]
  end

  def message!(options, **)
    options['result.message'] = 'Track removed'
  end

  def error!(options, **)
    options['result.message'] = 'Track not removed!!!'
  end
end