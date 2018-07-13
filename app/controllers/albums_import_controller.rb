class AlbumsImportController < ApplicationController
  def new
    # input = params.permit(:path)
    # AlbumsImport::Prepare.new.(path: params[:path]) do |m|
    Library::CollectInfo.new.(path: params[:path]) do |m|
      m.success { |value| render json: value }
      m.failure { |error| render_error error }
    end
  end

  def create
    Library::ImportAlbums.new.(albums: params[:albums]) do |m|
      m.success { |result| render json: result }
      m.failure { |error| render_error error }
    end
  end
end
