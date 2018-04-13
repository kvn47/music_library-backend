class AlbumsController < ApplicationController

  def index
    run Album::Index do
      return represent Album::Representer::Base.for_collection
    end
    render_error
  end

  def show
    run Album::Show do
      return represent Album::Representer::Show
    end
    render_error
  end

  def create
    run Album::Create do
      return represent Album::Representer::Base
    end
    render_error
  end

  def update
    run Album::Update do
      return represent Album::Representer::Base
    end
    render_error
  end

  def destroy
    run Album::Delete do
      return render json: {id: params[:id]}
    end
    render_error
  end
end
