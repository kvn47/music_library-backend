class Track::Delete < BaseOperation
  step Model(Track, :find_by)
  step :delete!

  def delete!(_options, model:, **)
    model.destroy
  end
end