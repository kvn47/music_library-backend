class SettingsController < ApplicationController

  def index
    render json: MusicLibrary.config
  end

  def update
    run Setting::Update do
      return render json: {message: 'ok'}
    end
    render_error
  end
end
