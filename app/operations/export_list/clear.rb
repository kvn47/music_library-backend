class ExportList::Clear < ATransaction
  try :find_export_list, catch: ActiveRecord::RecordNotFound
  step :process

  def find_export_list(id:, **)
    export_list = ExportList.find(id)
    {export_list: export_list}
  end

  def process(export_list:)
    export_list.tracks.clear
    Success export_list
  end
end
