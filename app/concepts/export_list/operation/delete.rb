class ExportList::Delete < BaseOperation
  step Model(ExportList, :find_by)
  failure :record_not_found!
  step :delete!
  failure :operation_failed!

  def delete!(_options, model:, **)
    model.destroy
  end
end
