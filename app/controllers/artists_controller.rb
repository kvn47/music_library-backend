class ArtistsController < ApplicationController

  def index
    run Artist::Index do
      return represent_model Artist::Representer::Base.for_collection
    end
    render_error
  end

  def show
    run Artist::Show do
      return represent_model Artist::Representer::Show
    end
    render_error
  end

  def create
    run Artist::Create do
      return represent_model Artist::Representer::Base
    end
    render_error
  end

  def update
    run Artist::Update do
      return represent_model Artist::Representer::Base
    end
    render_error
  end

  def destroy
    run Artist::Delete do
      return render json: {id: params[:id]}
    end
    render_error
  end
end
