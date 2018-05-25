require 'rails_helper'

RSpec.describe Library::Import do
  subject(:result) { described_class.(params: params) }

  let(:source_path) { '' }

  let(:params) do
    result = Library::PrepareImport.(params: {path: source_path})
    JSON.parse result['model']
  end

  it { is_expected.to be_success }

  it 'returns result message' do
    expect(result['result.message']).to eq('success')
  end
end
