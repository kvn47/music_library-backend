class Tracklist::Delete < BaseOperation
  step Model(Tracklist, :find_by)
  failure :record_not_found!
  step :delete!
  failure :operation_failed!

  def delete!(model:, **)
    model.destroy
  end
end
