require 'rails_helper'

RSpec.describe Library::PrepareImport do
  let(:source_path) { '' }

  it 'returns albums with tracks' do
    result = described_class.(params: {path: source_path})
    expect(result['model']).to include_json([])
  end
end
