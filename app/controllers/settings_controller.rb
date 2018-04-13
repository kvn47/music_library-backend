class SettingsController < ApplicationController

  def index
    render json: {library_path: MusicLibrary.config[:library_path]}
  end

  def update
    run Setting::Update do
      return render json: {message: 'ok'}
    end
    render_error
  end
end