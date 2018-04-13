class HomeController < ApplicationController

  def index
    respond_to :html
    render layout: false
  end
end