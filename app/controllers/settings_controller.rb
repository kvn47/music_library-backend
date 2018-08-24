class SettingsController < ApplicationController

  def index
    render json: MusicLibrary.config
  end

  def update
    run Settings::Update do |r|
      r.success { |settings| render json: settings, status: :ok }
      r.failure { |error| render_error error }
    end
  end
end
