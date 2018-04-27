require 'rails_helper'

RSpec.describe 'Notes API' do
  describe 'GET /api/notes' do
    subject do
      get '/api/notes'
      response.body
    end

    let!(:notes) { create_list :note, 2 }

    it 'returns notes' do
      is_expected.to include_json([
                                    {id: notes.first.id, artist: notes.first.artist, album: notes.first.album},
                                    {id: notes.second.id, artist: notes.second.artist, album: notes.second.album},
                                  ])
    end
  end
end
