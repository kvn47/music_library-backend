module ActionMethods
  private

  def run(operation_class, params: nil, step_args: nil, &block)
    params ||= action_params
    operation = operation_class.new
    operation = operation.with_step_args(step_args) if step_args

    if block_given?
      operation.(params, &block)
    else
      operation.(params) do |m|
        m.success { |model| represent model }
        m.failure { |error| render_error error }
      end
    end
  end

  def action_params
    params.to_unsafe_h.symbolize_keys
  end

  def model_class
    @model_class ||= controller_name.classify.constantize
  end

  def contract
    "#{model_class}Contract".safe_constantize
  end

  def represent(model, representer: nil, version: nil, status: :ok)
    representer ||= Object.const_get("#{model.model_name.name}Representer")
    representation = representer.represent(model, ActiveRecord::Relation)
    render json: representation.to_json(version: version), status: status
  end

  def render_error(error, status: nil)
    status ||= {
      record_not_found: :not_found,
      invalid_params: :not_acceptable
    }.fetch(error, 400)

    error_message = I18n.t("errors.operation.#{error}", default: error.to_s)
    render json: {message: error_message}, status: status
  end
end
