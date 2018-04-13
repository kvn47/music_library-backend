class ImportController < ApplicationController
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
