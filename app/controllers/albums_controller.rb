class AlbumsController < ApplicationController
  include BaseIndexAction

  def collect_info
    render json: {}, status: :ok
  end
end
