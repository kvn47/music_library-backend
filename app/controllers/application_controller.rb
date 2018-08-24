class ApplicationController < ActionController::API
  # protect_from_forgery with: :exceptiosn

  private

  def run(operation_class, steps: nil, step_args: nil, params: action_params, &block)
    operation = operation_class.new
    operation = operation.with_step_args(step_args) unless step_args.nil?
    operation.(params, &block)
  end

  def represent(model, representer: nil, version: nil, status: :ok)
    representer ||= Object.const_get("#{model.model_name.name}Representer")
    representation = representer.represent(model, ActiveRecord::Relation)
    render json: representation.to_json(version: version), status: status
  end

  def render_error(error, status: nil)
    status ||= {
      unauthorized: :unauthorized,
      record_not_found: :not_found,
      invalid_params: :not_acceptable
    }.fetch(error, 400)

    error_message = I18n.t("errors.operation.#{error}", default: error.to_s)
    render json: {error: error_message}, status: status
  end

  def action_params
    @action_params ||= params.to_unsafe_h.symbolize_keys.except(:controller, :action)
  end
end
