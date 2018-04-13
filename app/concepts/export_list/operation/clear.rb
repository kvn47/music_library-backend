class ExportList::Clear < BaseOperation
  step Model(ExportList, :find_by)
  failure :record_not_found!, fail_fast: true
  step :process!
  step :message!

  def process!(*, model:, **)
    model.tracks.clear
  end

  def message!(options, **)
    options['result.message'] = 'ExportList cleared'
  end
end