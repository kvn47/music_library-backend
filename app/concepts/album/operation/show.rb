class Album::Show < BaseOperation
  step Model(Album, :find_by)
end