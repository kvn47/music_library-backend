module ActionsHelpers
  def base_create_action(attributes: nil)
    attributes ||= declared_params
    model = model_class.new(attributes)

    model.save ? present_model(model) : present_model_errors(model)
  end

  def base_update_action
    model = find_model

    model.update(declared_params) ? present_model(model) : present_model_errors(model)
  end

  def base_destroy_action
    model = find_model

    model.destroy ? status(:ok) : present_model_errors(model)
  end

  def base_index_action
    collection = model_class.query(**declared_params)
    present collection
  end

  def base_show_action
    model = find_model
    present_model model, type: :full
  end

  def run_operation(operation_class, input: nil, step_args: nil, &block)
    input ||= declared_params
    operation = operation_class.new
    operation = operation.with_step_args(step_args) if step_args

    if block_given?
      operation.(input, &block)
    else
      operation.(input) do |m|
        m.success(&method(:present_model))
        m.failure(&method(:present_error))
      end
    end
  end

  def declared_params
    declared(params).symbolize_keys
  end

  def model_class
    namespace_inheritable(:model_class) || namespace_setting(:model_class) || route_setting(:model_class)
  end

  def find_model
    model_class.find(params[:id])
  end

  def present_model(model, presenter_class: nil, type: nil)
    presenter_class ||= "#{model.model_name.name}Presenter".safe_constantize
    present model, with: presenter_class, type: type
  end

  def present_error(error, status: nil)
    status ||= 400
    error!({message: error}, status)
  end

  def present_model_errors(model)
    present_error model.errors.full_messages.to_sentence
  end
end
