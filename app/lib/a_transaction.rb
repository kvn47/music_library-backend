class ATransaction
  include ACallable
  include Dry::Transaction

  private

  def validate(params, contract)
    result = contract.(params)
    result.success? ? Success(result.output) : Failure(result.messages)
  end

  def find_record(model_class:, id:, **params)
    record = model_class.find_by id: id
    record_key = model_class.model_name.singular.to_sym

    if record
      Success params.merge(record_key => record)
    else
      Failure :record_not_found
    end
  end
end
