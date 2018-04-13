require 'rails_helper'

RSpec.describe "Settings API" do
  describe "GET /api/settings" do
    subject do
      get '/api/settings'
      response.body
    end

    it "returns 'library_path'" do
      is_expected.to include_json(library_path: MusicLibrary.config[:library_path])
    end
  end
end
