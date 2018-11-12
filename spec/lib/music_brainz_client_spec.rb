require 'rails_helper'
require_relative '../../lib/music_brainz_client'

RSpec.describe MusicBrainzClient do
  describe "#call" do
    subject(:response) { described_class.new.('artist', query: 'Bach') }

    it 'returns result' do
      expect(response).not_to be_nil
    end
  end

  describe "#release" do
    subject!(:response) { described_class.new.release(mbid: 'a04aa202-1a86-4b55-9072-d176550384c7') }
    # subject!(:response) { described_class.new.release(artist: 'Marc-André Hamelin, London Philharmonic Orchestra, Vladimir Jurowski', title: 'Medtner & Rachmaninov: Piano Concertos') }
    # subject!(:response) { described_class.new.release(artist: 'Hilary Hahn', title: 'Brahms & Stravinsky Violin Concertos') }

    it 'returns release details' do
      expect(response).to include(:id)
    end
  end

  describe "#search_release" do
    subject!(:response) { described_class.new.search_release(artist: 'few', title: 'vds') }
    # subject!(:response) { described_class.new.search_release(artist: 'Marc-André Hamelin, London Philharmonic Orchestra, Vladimir Jurowski', title: 'Medtner & Rachmaninov: Piano Concertos') }
    # subject!(:response) { described_class.new.search_release(artist: 'Hilary Hahn', title: 'Brahms & Stravinsky Violin Concertos') }

    it 'returns release info' do
      expect(response).to include(:id)
    end
  end

  describe "#recording" do
    subject!(:response) { described_class.new.recording(id: 'afa019dd-30f0-4053-86e2-603e6ae3c46c') }
  end
end
