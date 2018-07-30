class LibraryController < ApplicationController
  def update
    Library::Rescan.() do |r|
      r.success { |value| render json: {message: value} }
      r.failure { |_error| render_error }
    end
  end
end
