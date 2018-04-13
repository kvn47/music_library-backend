class Note::Delete < BaseOperation
  step Model(Note, :find_by)
  failure :record_not_found!
  step :delete!
  failure :operation_failed!

  private

  def delete!(model:, **)
    model.destroy
  end
end
