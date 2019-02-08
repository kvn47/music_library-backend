require 'rails_helper'

RSpec.describe NotesAPI do
  describe 'GET /api/notes' do
    before do
      create_list :note, 2
      get '/api/notes'
    end

    it 'returns notes' do
      expect(response.body).to include_json([
                                              {id: Note.first.id, artist: Note.first.artist, album: Note.first.album},
                                              {id: Note.second.id, artist: Note.second.artist, album: Note.second.album},
                                            ])
    end
  end

  describe 'GET /api/notes/:id' do
    before do
      get "/api/notes/#{note.id}"
    end

    let(:note) { create :note }

    it 'returns note' do
      expect(response.body).to include_json(id: note.id, artist: note.artist, album: note.album)
    end
  end

  describe 'POST /api/notes' do
    subject! do
      post '/api/notes', params: params
      response
    end

    let(:params) { attributes_for(:note) }

    include_examples "successful create response"

    it 'returns created note' do
      expect(response.body).to include_json(params.as_json)
    end
  end

  describe 'PATCH /api/notes/:id' do
    subject! do
      patch "/api/notes/#{note.id}", params: params
      response
    end

    let(:note) { create :note }
    let(:params) { {artist: 'Another Artist', album: 'Another Album'} }

    include_examples "successful response"

    it 'returns updated note' do
      expect(response.body).to include_json(params.as_json)
    end
  end

  describe "DELETE /api/notes/:id" do
    subject! do
      delete "/api/notes/#{note.id}"
      response
    end
    
    let(:note) { create :note }
    
    include_examples "successful response"
  end
end
