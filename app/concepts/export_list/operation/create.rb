class ExportList::Create < BaseOperation
  class Present < BaseOperation
    step Model(ExportList, :new)
    step Contract.Build(constant: ExportList::Contract::Base)
  end

  step Nested(Present)
  step Contract.Validate
  failure :contract_invalid!
  step Contract.Persist
  failure :operation_failed!
end
