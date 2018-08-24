require 'rails_helper'

RSpec.describe NotesController do
  describe "POST create" do
    before { post :create, params: {kind: 'listen', artist: 'Artist'} }

    it "has HTTP status 201 (created)" do
      expect(response).to have_http_status(:created)
    end
  end
end
