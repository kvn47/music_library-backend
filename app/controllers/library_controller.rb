class LibraryController < ApplicationController
  def update
    run Library::Rescan do |r|
      r.success { |value| render json: {message: value} }
      r.failure { |error| render_error error }
    end
  end
end
