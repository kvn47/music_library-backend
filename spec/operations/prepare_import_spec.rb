require 'rails_helper'

RSpec.describe PrepareImport do
  let(:source_path) { '' }

  it 'returns albums with tracks' do
    result = subject.(path: source_path)
    expect(result).to include_json([])
  end
end
