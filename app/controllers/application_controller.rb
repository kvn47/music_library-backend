class ApplicationController < ActionController::API
  include Trailblazer::Rails::Controller
  # protect_from_forgery with: :exceptiosn

  private

  def represent(representer_class, model = nil)
    model ||= @model
    render json: representer_class.new(model).to_json
  end

  def render_error(error = nil)
    error ||= result_message || 'error'
    render json: {error: error}
  end

  def result_message
    @_result['result.message']
  end
end
