class ExportList::Update < BaseOperation
  class Present < BaseOperation
    step Model(ExportList, :find_by)
    failure :record_not_found!
    step Contract.Build(constant: ExportList::Contract::Base)
  end

  step Nested(Present)
  step Contract.Validate
  failure :contract_invalid!
  step Contract.Persist
  failure :operation_failed!
end
