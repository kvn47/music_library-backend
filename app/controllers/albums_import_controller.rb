class AlbumsImportController < ApplicationController
  def new
    Import::CollectInfo.new.(path: params[:path]) do |m|
      m.success { |value| render json: value }
      m.failure { |error| render_error error }
    end
  end

  def create
    Import::Perform.new.(params.to_unsafe_h) do |m|
      m.success { |result| render json: result }
      m.failure { |error| render_error error }
    end
  end
end
