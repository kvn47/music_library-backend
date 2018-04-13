class Tracklist::Create < BaseOperation
  class Present < BaseOperation
    step Model(Tracklist, :new)
    step Contract.Build(constant: Tracklist::Contract::Base)
  end

  step Nested(Present)
  step Contract.Validate
  failure :contract_invalid!
  step Contract.Persist
  failure :operation_failed!
end
