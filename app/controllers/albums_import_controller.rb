class AlbumsImportController < ApplicationController
  def new
    Import::CollectInfo.new.(path: params[:path]) do |r|
      r.success { |value| render json: value }
      r.failure { |error| render_error error }
    end
  end

  def create
    Import::Perform.new.(params.to_unsafe_h) do |r|
      r.success { |result| render json: result }
      r.failure { |error| render_error error }
    end
  end
end
