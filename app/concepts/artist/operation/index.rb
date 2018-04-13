class Artist::Index < BaseOperation
  step :model!
  failure :operation_failed!

  def model!(options, **)
    options[:model] = Artist.ordered
  end
end
