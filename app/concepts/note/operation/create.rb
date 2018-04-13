class Note::Create < BaseOperation
  step Model(Note, :new)
  step Contract.Build(constant: Note::Contract::Base)
  step Contract.Validate
  failure :contract_invalid!
  step Contract.Persist
  failure :operation_failed!
end
