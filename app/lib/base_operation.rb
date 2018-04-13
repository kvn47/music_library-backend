class BaseOperation < Trailblazer::Operation

  private

  def record_not_found!(options, **)
    options['result.message'] ||= 'Record not found!'
    Railway.fail_fast!
  end

  def contract_invalid!(options, **)
    errors = options['contract.default'].errors.to_s
    options['result.message'] ||= "Invalid params! #{errors}"
    Railway.fail_fast!
  end

  def operation_failed!(options, **)
    options['result.message'] ||= 'Operation failed!'
    Railway.fail_fast!
  end
end