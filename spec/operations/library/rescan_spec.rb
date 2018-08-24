require 'rails_helper'

RSpec.describe Library::Rescan do
  subject!(:result) { described_class.() }

  it { is_expected.to be_success }

  it 'creates Album' do
    expect(Album.count).to eq(4)
  end
end
