require 'rails_helper'
require_relative '../../lib/structure_album_files'

RSpec.describe StructureAlbumFiles do
  subject(:result) { described_class.(path) }

  # let(:path) { '/Users/vova/Downloads/Tchaikovsky, Myaskovsky - Violin Concertos - Repin, Gergiev' }
  let(:path) { '/Users/vova/Downloads/TesseracT - Sonder  (2018) [Kscope Records, KSCOPE472]' }

  it 'should be success' do
    expect(result).to eq(0)
  end
end
