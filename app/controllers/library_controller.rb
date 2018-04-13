class LibraryController < ApplicationController
  def update
    run Library::Update do
      return render json: {message: 'ok'}
    end
    render_error
  end
end
