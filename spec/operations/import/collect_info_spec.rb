require 'rails_helper'

RSpec.shared_examples 'albums info' do

  it 'returns import information' do
    expect(result).to contain_exactly(import_info)
  end

  it 'contains tracks information' do
    expect(result[0][:albums][0][:tracks]).to contain_exactly(*import_info[:albums][0][:tracks])
  end
end

RSpec.describe Import::CollectInfo, :import do
  subject(:result) { described_class.new.(path: path).value }

  context 'one album separate flac files without cue' do
    let(:path) { import_path('Toundra - Vortex - 2018') }

    let(:import_info) do
      {
        albums: [
          {
            artist: 'Toundra',
            title: 'Vortex',
            genre: 'Instrumental Rock',
            year: 2018,
            cover: 'cover.jpg',
            tracks: [
              {number: 1, title: 'Intro Vortex', file: '01. Intro Vortex.flac'},
              {number: 2, title: 'Cobra', file: '02. Cobra.flac'},
              {number: 3, title: 'Tuareg', file: '03. Tuareg.flac'},
              {number: 4, title: 'Cartavio', file: '04. Cartavio.flac'},
              {number: 5, title: 'Kingston Falls', file: '05. Kingston Falls.flac'},
              {number: 6, title: 'Mojave', file: '06. Mojave.flac'},
              {number: 7, title: 'Roy Neary', file: '07. Roy Neary.flac'},
              {number: 8, title: 'Cruce Oeste', file: '08. Cruce Oeste.flac'}
            ]
          }
        ]
      }
    end

    include_examples 'albums info'
  end

  context 'one album separate flac files with cue' do
    let(:path) { import_path('TesseracT - Sonder - 2018') }

    let(:import_info) do
      {
        albums: [
          {
            artist: 'TesseracT',
            title: 'Sonder',
            genre: 'Progressive Metal',
            year: 2018,
            cover: 'cover.png',
            tracks: [
              {number: 1, title: 'Luminary', file: '01. Luminary.flac'},
              {number: 2, title: 'King', file: '02. King.flac'},
              {number: 3, title: 'Orbital', file: '03. Orbital.flac'},
              {number: 4, title: 'Juno', file: '04. Juno.flac'},
              {number: 5, title: 'Beneath My Skin', file: '05. Beneath My Skin.flac'},
              {number: 6, title: 'Mirror Image', file: '06. Mirror Image.flac'},
              {number: 7, title: 'Smile', file: '07. Smile.flac'},
              {number: 8, title: 'The Arrow', file: '08. The Arrow.flac'}
            ]
          }
        ]
      }
    end

    include_examples 'albums info'
  end

  context 'one album in single flac file with cue' do
    let(:path) { import_path('Tchaikovsky, Myaskovsky - Violin Concertos - Repin, Gergiev') }

    let(:import_info) do
      {
        cue: 'Vadim Repin (violin), Valery Gergiev & Kirov Orchestra - Tchaikovsky & Myaskovsky Violin Concertos.cue',
        file: 'Vadim Repin (violin), Valery Gergiev & Kirov Orchestra - Tchaikovsky & Myaskovsky Violin Concertos.flac',
        albums: [
          {
            artist: 'Vadim Repin (violin), Valery Gergiev & Kirov Orchestra',
            title: 'Tchaikovsky & Myaskovsky Violin Concertos',
            genre: 'Classical',
            cover: nil,
            tracks: [
              {number: 1, title: 'Tchaikovsky Violin Concerto in D major, op.35 - I. Allegro moderato', cue_track: 1},
              {number: 2, title: 'Tchaikovsky Violin Concerto in D major, op.35 - I. II. Canzonetta', cue_track: 2},
              {number: 3, title: 'Tchaikovsky Violin Concerto in D major, op.35 - I. III. Finale, Allegro vivac...', cue_track: 3},
              {number: 4, title: 'Myaskovsky Violin Concerto in D minor, op.44 - I. Allegro', cue_track: 4},
              {number: 5, title: 'Myaskovsky Violin Concerto in D minor, op.44 - II. Adagio e molto cantabile', cue_track: 5},
              {number: 6, title: 'Myaskovsky Violin Concerto in D minor, op.44 - III. Allegro molto - Allegro s...', cue_track: 6}
            ]
          }
        ]
      }
    end

    include_examples 'albums info'
  end

  # context 'two albums in nested separate flac files with cue' do
  #   let(:path) { import_path('Opeth - Sorceress (2016 Deluxe Edition)') }
  #
  #   let(:album_info) do
  #     {
  #       artist: 'Opeth',
  #       title: 'Sorceress (Disc 1)'
  #     }
  #   end
  #
  #   let(:track_info) { {title: 'Persephone', path: File.join(path, 'Disc 1/01 - Persephone.flac')} }
  #
  #   include_examples 'albums info'
  # end
end
