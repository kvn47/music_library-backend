class Note::Update < BaseOperation
  step Model(Note, :find_by)
  failure :record_not_found!
  step Contract.Build(constant: Note::Contract::Base)
  step Contract.Validate
  failure :contract_invalid!
  step Contract.Persist
  failure :operation_failed!
end
