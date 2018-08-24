require 'rails_helper'

RSpec.describe 'Albums API' do
  describe 'GET /api/artists/:id/albums' do
    subject do
      get "/api/artists/#{artist.id}/albums"
      response.body
    end

    let(:artist) { create :artist }
    let!(:albums) { create_list :album, 2, artist: artist }

    it "returns artist's albums" do
      is_expected.to include_json([{id: albums.first.id, title: albums.first.title}])
    end
  end
end
