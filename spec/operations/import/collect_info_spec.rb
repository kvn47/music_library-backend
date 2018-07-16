require 'rails_helper'

RSpec.shared_examples 'albums info' do

  it 'returns albums information' do
    expect(result).to include(a_collection_including(album_info))
  end

  it 'returns tracks information' do
    expect(result[0][:tracks]).to include(a_collection_including(track_info))
    # expect(result).to include(a_collection_including(tracks: a_collection_including(track_info)))
  end
end

RSpec.describe Import::CollectInfo, :import do
  subject(:result) { described_class.new.(path: path).value }

  context 'one album separate flac files without cue' do
    let(:path) { '/Users/vova/Music/Shinedown - 2018 - Attention Attention [FLAC] [CD]' }
    let(:album_info) { {artist: 'Shinedown', title: 'ATTENTION ATTENTION'} }
    let(:track_info) { {title: 'DEVIL', path: '/Users/vova/Music/Shinedown - 2018 - Attention Attention [FLAC] [CD]/02. DEVIL.flac'} }

    include_examples 'albums info'
  end

  context 'one album separate flac files with cue' do
    let(:path) { '/Users/vova/Downloads/Music/TesseracT - Sonder  (2018) [Kscope Records, KSCOPE472]' }
    let(:album_info) { {artist: 'TesseracT', title: 'Sonder'} }
    let(:track_info) { {title: 'Luminary', path: '/Users/vova/Music/TesseracT - Sonder  (2018) [Kscope Records, KSCOPE472]/01 - Luminary.flac'} }

    include_examples 'albums info'
  end

  context 'one album in single flac file with cue' do
    let(:path) { '/Users/vova/Downloads/Music/Tchaikovsky, Myaskovsky - Violin Concertos - Repin, Gergiev' }

    let(:album_info) do
      {
        artist: 'Vadim Repin (violin), Valery Gergiev & Kirov Orchestra',
        title: 'Tchaikovsky & Myaskovsky Violin Concertos'
      }
    end

    let(:track_info) { {title: 'Tchaikovsky Violin Concerto in D major, op.35 - I. Allegro moderato', path: '/Users/vova/Downloads/Music/Tchaikovsky, Myaskovsky - Violin Concertos - Repin, Gergiev/Vadim Repin (violin), Valery Gergiev & Kirov Orchestra - Tchaikovsky & Myaskovsky Violin Concertos.flac'} }

    include_examples 'albums info'
  end

  context 'two albums in nested separate flac files with cue' do
    let(:path) { '/Users/vova/Music/Opeth - Sorceress (2016 Deluxe Edition)' }

    let(:album_info) do
      {
        artist: 'Opeth',
        title: 'Sorceress (Disc 1)'
      }
    end

    let(:track_info) { {title: 'Persephone', path: '/Users/vova/Music/Opeth - Sorceress (2016 Deluxe Edition)/Disc 1/01 - Persephone.flac'} }

    include_examples 'albums info'
  end
end
