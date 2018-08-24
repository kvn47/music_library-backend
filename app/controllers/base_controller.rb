class BaseController < ApplicationController
  def index
    collection = model_class.ordered
    represent collection
  end

  def show
    model = model_class.find_by(id: params[:id])
    model ? represent(model, version: :full) : render_error(:record_not_found)
  end

  def create
    run CreateModel, step_args: {validate: [contract], create: [model_class]} do |r|
      r.success { |model| represent model, status: :created }
      r.failure { |error| render_error error }
    end
  end

  def update
    run UpdateModel, step_args: {validate: [contract], update: [model_class, params[:id]]} do |r|
      r.success { |model| represent model }
      r.failure { |error| render_error error }
    end
  end

  def destroy
    run DestroyModel, step_args: {destroy: [model_class]} do |r|
      r.success { |model| represent model }
      r.failure { |error| render_error error }
    end
  end

  private

  def model_class
    @model_class ||= begin
      class_name = self.class.name.sub('Controller', '').singularize
      Object.const_get class_name
    end
  end

  def params_validator
    ValidateParams.new
  end

  def contract
    Object.const_get "#{model_class}Contract"
  end
end
