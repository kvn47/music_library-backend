class Track::Show < BaseOperation
  step Model(Track, :find_by)
end