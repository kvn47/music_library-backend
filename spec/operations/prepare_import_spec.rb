require 'rails_helper'

RSpec.describe PrepareImport, :import do
  it 'returns albums' do
    albums = subject.(path: import_source).value
    expect(albums).to include(a_collection_including(:artist, :title, :tracks))
  end
end
