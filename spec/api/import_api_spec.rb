require 'rails_helper'

RSpec.describe 'Import API', :import do
  describe 'GET /api/albums_import/new' do
    subject do
      get '/api/albums_import/new', params: {path: import_path('Tchaikovsky, Myaskovsky - Violin Concertos - Repin, Gergiev')}
      response.body
    end

    it 'returns albums' do
      is_expected.to include_json([])
    end
  end
end
