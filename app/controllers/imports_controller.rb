class ImportsController < ApplicationController
  def new
    # input = params.permit(:path)
    PrepareImport.new.(path: params[:path]) do |m|
      m.success { |value| render json: value }
      m.failure { |error| render_error error }
    end
  end

  def prepare
    run Library::PrepareImport do
      return render json: @model.to_json
    end
    render_error
  end

  def create
    run Library::Import
    render json: {message: 'Import finished.', result: result_message}
  end
end
