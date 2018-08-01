class ExportListsController < ApplicationController

  def index
    run ExportList::Index do
      return represent_model ExportList::Representer::Base.for_collection
    end
    render_error
  end

  def show
    run ExportList::Show do
      return represent_model ExportList::Representer::Show
    end
    render_error
  end

  def create
    run ExportList::Create do
      return represent_model ExportList::Representer::Base
    end
    render_error
  end

  def update
    run ExportList::Update do
      return represent_model ExportList::Representer::Base
    end
    render_error
  end

  def destroy
    run ExportList::Delete do
      return render json: {id: params[:id]}
    end
    render_error
  end

  def add
    run ExportList::Add do
      return represent_model ExportList::Representer::Show
    end
    render_error
  end

  def remove
    run ExportList::Remove do
      return represent_model ExportList::Representer::Show
    end
    render_error
  end

  def clear
    run ExportList::Clear do
      return represent_model ExportList::Representer::Show
    end
    render_error
  end

  def export
    run ExportList::Export do |result|
      return render json: {message: result['result.message']}
    end
    render_error
  end
end
