class ExportList::Index < BaseOperation
  step :model!

  def model!(options, **)
    options[:model] = ExportList.ordered
  end
end