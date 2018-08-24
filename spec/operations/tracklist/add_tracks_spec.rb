require 'rails_helper'

RSpec.describe Tracklist::AddTracks do
  subject(:result) { described_class.new.(params.merge(id: tracklist.id)) }

  let(:tracklist) { create :tracklist }
  let(:artist) { create :artist }
  let(:album) { create :album, artist: artist }
  let!(:track) { create :track, album: album }

  context "when 'track_id' given" do
    let(:params) { {track_id: track.id} }

    it "returns 'tracklist' with that track" do
      expect(result.value.tracks).to include(track)
    end
  end

  context "when 'album_id' given" do
    let(:params) { {album_id: album.id} }

    it "returns 'tracklist' with that track" do
      expect(result.value.tracks).to include(track)
    end
  end

  context "when 'artist_id' given" do
    let(:params) { {artist_id: artist.id} }

    it "returns 'tracklist' with that track" do
      expect(result.value.tracks).to include(track)
    end
  end
end
