require 'rails_helper'

RSpec.describe AutoImport, :import do
  subject(:result) { described_class.new.(path: path) }

  context 'one album separate flac files' do
    let(:path) { import_path('Toundra - Vortex - 2018') }

    it { is_expected.to be_success, result.failure }
  end

  context 'two albums from one flac file with cue' do
    let(:path) { import_path('Tchaikovsky, Myaskovsky - Violin Concertos - Repin, Gergiev') }

    it { is_expected.to be_success }
  end
end
