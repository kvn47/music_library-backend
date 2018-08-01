module ModelController
  def index
    collection = model_class.all
    represent collection, :collection
  end

  def show
    model = model_class.find_by(id: params[:id])
    model ? represent(model, :show) : render_error('record not found')
  end

  def create
    CreateModel
      .new(validate: params_validator)
      .with_step_args(validate: [contract], create: [model_class])
      .(params_hash) do |result|
      result.success { |model| represent model }
      result.failure { |error| render_error error }
    end
  end

  def update
    UpdateModel
      .new(validate: params_validator)
      .with_step_args(validate: [contract], update: [model_class, params[:id]])
      .(params_hash) do |result|
      result.success { |model| represent model }
      result.failure { |error| render_error error }
    end
  end

  def destroy
    DestroyModel.new.with_step_args(destroy: [model_class]).(params_hash) do |result|
      result.success { |model| represent model }
      result.failure { |error| render_error error }
    end
  end

  private

  def params_hash
    params.to_unsafe_h.symbolize_keys
  end

  def params_validator
    ValidateParams.new
  end

  def represent(model, variant = :base)
    if variant == :collection
      render json: representer_class.for_collection.new(model).to_json
    else
      render json: representer_class.new(model).to_json
    end
  end

  def contract
    raise NotImplementedError
  end

  def model_class
    raise NotImplementedError
  end

  def representer_class
    raise NotImplementedError
  end
end
