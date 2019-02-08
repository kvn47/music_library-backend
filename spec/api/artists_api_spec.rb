require 'rails_helper'

RSpec.describe ArtistsAPI do
  describe "GET /api/artists" do
    subject do
      get '/api/artists'
      response.body
    end

    let!(:artists) { create_list :artist, 2 }

    it 'returns artists' do
      expected_result = artists.map { |artist| {id: artist.id, name: artist.name} }
      is_expected.to include_json(expected_result)
    end
  end

  describe 'GET /api/artists/:id' do
    subject do
      get "/api/artists/#{artist.id}"
      response.body
    end

    let(:artist) { create :artist }

    it 'returns artist' do
      is_expected.to include_json(id: artist.id, name: artist.name, image_thumb_url: artist.image_thumb_url)
    end
  end

  describe 'POST /api/artists' do
    subject! { post '/api/artists', params: params }

    let(:params) { attributes_for :artist }

    it 'returns created artist' do
      expect(response.body).to include_json(name: params[:name])
    end
  end

  describe 'PATCH /api/artists/:id' do
    subject! do
      artist = create :artist
      patch "/api/artists/#{artist.id}", params: params
    end

    let(:params) { {name: 'New artist'} }

    it 'returns updated artist' do
      expect(response.body).to include_json(name: params[:name])
    end
  end

  describe 'DELETE /api/artists/:id' do
    subject! { delete "/api/artists/#{artist.id}" }

    let(:artist) { create :artist }

    include_examples "successful response"
  end
end
