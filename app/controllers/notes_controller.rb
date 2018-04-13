class NotesController < ApplicationController
  def index
    run Note::Index do
      return represent Note::Representer::Base.for_collection
    end
    render_error
  end

  def show
    run Note::Show do
      return represent Note::Representer::Show
    end
    render_error
  end

  def create
    run Note::Create do |result|
      return represent Note::Representer::Base, result['model']
    end
    render_error
  end

  def update
    run Note::Update do
      return represent Note::Representer::Base
    end
    render_error
  end

  def destroy
    run Note::Delete do
      return render json: params.slice(:id)
    end
    render_error
  end
end
