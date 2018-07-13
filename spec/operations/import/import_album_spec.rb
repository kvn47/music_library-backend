require 'rails_helper'

RSpec.describe Import::ProcessAlbum, :import do
  subject(:result) { described_class.new.(import_params) }

  let(:import_params) do
    {
        artist: 'Чайковский',
        title: 'Violin Concerto In D Major, Op.35',
        year: '1878',
        cover: '',
        tracks: [
          {number: '1', title: 'I. Allegro Moderato', path: '/Users/vova/Downloads/Music/Tchaikovsky, Myaskovsky - Violin Concertos - Repin, Gergiev/?.flac'},
          {number: '2', title: 'II. Canzonetta', path: '/Users/vova/Downloads/Music/Tchaikovsky, Myaskovsky - Violin Concertos - Repin, Gergiev/?.flac'},
          {number: '3', title: 'III. Finale: Allegro vivacissimo', path: '/Users/vova/Downloads/Music/Tchaikovsky, Myaskovsky - Violin Concertos - Repin, Gergiev/?.flac'}
        ]
      }
  end

  it { is_expected.to be_success }
end
