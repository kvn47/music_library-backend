require 'rails_helper'

RSpec.describe "AlbumContract" do
  subject(:validation) { AlbumContract.(params) }

  let(:params) { {title: 'Album', artist_id: artist.id} }
  let(:artist) { build_stubbed :artist }

  it 'success' do
    expect(validation).to be_success, validation.messages
  end
end
