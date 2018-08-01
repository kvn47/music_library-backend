class ApplicationController < ActionController::API
  include Trailblazer::Rails::Controller
  # protect_from_forgery with: :exceptiosn

  private

  # def params_hash
  #   params.to_unsafe_h.symbolize_keys
  # end

  def represent_model(representer_class, model: nil)
    model ||= @model
    render json: representer_class.new(model).to_json
  end

  def render_error(error = nil)
    error ||= result_message || 'error'
    render json: {message: error}, status: :bad_request
  end

  def result_message
    @_result['result.message']
  end
end
