class Artist::Show < BaseOperation
  step Model(Artist, :find_by)
  failure :record_not_found!
end
