require 'rails_helper'

RSpec.describe 'Import API' do
  describe 'GET /api/import/new' do
    subject do
      get '/api/import/new', params: {path: path}
      response.body
    end

    let(:path) { '' }

    it 'returns albums' do
      is_expected.to include_json([])
    end
  end
end
