class TracklistsController < ApplicationController
  def index
    run Tracklist::Index do
      return represent_model Tracklist::Representer::Base.for_collection
    end
    render_error
  end

  def show
    run Tracklist::Show do
      return represent_model Tracklist::Representer::Show
    end
    render_error
  end

  def create
    run Tracklist::Create do
      return represent_model Tracklist::Representer::Base
    end
    render_error
  end

  def update
    run Tracklist::Update do
      return represent_model Tracklist::Representer::Base
    end
    render_error
  end

  def destroy
    run Tracklist::Delete do
      return render json: {id: params[:id]}
    end
    render_error
  end

  def add_tracks
    run Tracklist::AddTracks do
      return represent_model Tracklist::Representer::Show
    end
    render_error
  end

  def remove_track
    run Tracklist::RemoveTrack do
      return represent_model Tracklist::Representer::Show
    end
    render_error
  end

  def clear
    run Tracklist::Clear do
      return represent_model Tracklist::Representer::Show
    end
    render_error
  end
end
