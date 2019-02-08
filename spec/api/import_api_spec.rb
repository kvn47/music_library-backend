require 'rails_helper'

RSpec.describe ImportAPI, :import do
  describe 'GET /api/albums_import/new' do
    subject! do
      get '/api/albums_import/new', params: {path: import_path('Tchaikovsky, Myaskovsky - Violin Concertos - Repin, Gergiev')}
    end

    it 'returns albums' do
      expect(response.body).to include_json([])
    end
  end
end
