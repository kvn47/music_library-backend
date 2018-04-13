class Album::Delete < BaseOperation
  step Model(Album, :find_by)
  step :delete!

  def delete!(_options, model:, **)
    model.destroy
  end
end