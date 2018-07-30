require 'rails_helper'

RSpec.describe Import::Auto, :import do
  subject(:result) { described_class.new.(path: path) }

  context 'one album separate flac files' do
    let(:path) { import_path('Toundra/2018 - Vortex') }

    it { is_expected.to be_success }
  end

  context 'two albums from one flac file with cue' do
    let(:path) { import_path('Tchaikovsky, Myaskovsky - Violin Concertos - Repin, Gergiev') }

    it { is_expected.to be_success }
  end
end
