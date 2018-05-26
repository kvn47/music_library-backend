require 'rails_helper'

RSpec.describe ImportAlbum, :import do
  let(:album_params) { PrepareImport.new.(path: import_source).value.first }

  subject(:result) { described_class.new.(album_params) }

  it { is_expected.to be_success }

  it 'returns created album' do
    expect(result.value).to be_persisted
  end
end
