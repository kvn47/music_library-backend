require 'rails_helper'

RSpec.describe Import::ProcessAlbum, :import do
  subject(:result) { described_class.new.(import_params) }

  let(:path) { import_path('TesseracT - Sonder - 2018') }

  let(:import_params) do
    {
        artist: 'Чайковский',
        title: 'Violin Concerto In D Major, Op.35',
        year: '1878',
        cover: '',
        tracks: [
          {number: '1', title: 'I. Allegro Moderato', path: File.join(path, 'Vadim Repin (violin), Valery Gergiev & Kirov Orchestra - Tchaikovsky & Myaskovsky Violin Concertos - 01.flac')},
          {number: '2', title: 'II. Canzonetta', path: File.join(path, 'Vadim Repin (violin), Valery Gergiev & Kirov Orchestra - Tchaikovsky & Myaskovsky Violin Concertos - 02.flac')},
          {number: '3', title: 'III. Finale: Allegro vivacissimo', path: File.join(path, 'Vadim Repin (violin), Valery Gergiev & Kirov Orchestra - Tchaikovsky & Myaskovsky Violin Concertos - 03.flac')}
        ]
      }
  end

  it do
    skip
    is_expected.to be_success
  end
end
