class Tracklist::Clear < BaseOperation
  step Model(Tracklist, :find_by)
  failure :record_not_found!, fail_fast: true
  step :clear!
  step :message!

  def clear!(model:, **)
    model.tracks.clear
  end

  def message!(options, **)
    options['result.message'] = 'Tracklist cleared'
  end
end