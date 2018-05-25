require 'rails_helper'

RSpec.describe ImportAlbum do
  let(:album_params) { {} }

  it 'returns created album' do
    album = subject.(album_params)
    expect(album).to be_persisted
  end
end
