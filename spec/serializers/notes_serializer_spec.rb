require 'rails_helper'

RSpec.describe NoteSerializer do
  # subject(:note_json) { described_class.new(note).serialized_json }
  subject(:note_json) { described_class.new(note).serializable_hash.dig(:data, :attributes).to_json }

  let(:note) { build_stubbed :note }

  it 'returns serialized note' do
    # is_expected.to include_json(data: {attributes: {id: note.id, kind: note.kind, artist: note.artist, album: note.album}})
    is_expected.to include_json(id: note.id, kind: note.kind, artist: note.artist, album: note.album)
  end

  it 'returns serialized notes' do
    notes = build_stubbed_list :note, 2
    notes_json = described_class.new(notes).serializable_hash
    expect(notes_json).to include_json([{id: notes[0].id, kind: notes[0].kind, artist: notes[0].artist, album: notes[0].album}])
  end
end
