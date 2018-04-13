class TracksController < ApplicationController

  def index
    run Track::Index do
      return represent Track::Representer::Base.for_collection
    end
    render_error
  end

  def create
    run Track::Create do
      return represent Track::Representer::Base
    end
    render_error
  end

  def update
    run Track::Update do
      return represent Track::Representer::Base
    end
    render_error
  end

  def destroy
    run Track::Delete do
      return render json: {id: params[:id]}
    end
    render_error
  end
end