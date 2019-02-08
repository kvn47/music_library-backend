require 'rails_helper'

RSpec.describe SettingsAPI do
  describe "GET /api/settings" do
    subject! { get '/api/settings' }

    it "returns 'library_path'" do
      expect(response.body).to include_json(library_path: MusicLibrary.config[:library_path])
    end
  end
end
