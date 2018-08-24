require 'rails_helper'

# RSpec.shared_examples 'importing album' do
#   it 'imports tracks in given album' do
#
#   end
# end

RSpec.describe Import::Perform, :import do
  subject!(:result) { described_class.new.(import_params) }

  context 'one album from separate flac files' do
    let(:import_params) do
      {
        path: import_path('Toundra - Vortex - 2018'),
        import_sources: [
          {
            albums: [
              {
                artist: 'Toundra',
                title: 'Vortex',
                genre: 'Instrumental Rock',
                year: 2018,
                cover: 'vortex.jpg',
                tracks: [
                  {number: 1, title: 'Intro Vortex', file: '01.intro_vortex.flac'},
                  {number: 2, title: 'Cobra', file: '02.cobra.flac'},
                  {number: 3, title: 'Tuareg', file: '03.tuareg.flac'},
                  {number: 4, title: 'Cartavio', file: '04.cartavio.flac'},
                  {number: 5, title: 'Kingston Falls', file: '05.kingston_falls.flac'},
                  {number: 6, title: 'Mojave', file: '06.mojave.flac'},
                  {number: 7, title: 'Roy Neary', file: '07.roy_neary.flac'},
                  {number: 8, title: 'Cruce Oeste', file: '08.cruce_oeste.flac'}
                ]
              }
            ]
          }
        ]
      }
    end

    it do
      skip
      is_expected.to be_success
    end
  end

  context 'two albums from one flac file with cue' do
    let(:path) { import_path('Tchaikovsky, Myaskovsky - Violin Concertos - Repin, Gergiev') }

    let(:import_params) do
      {
        path: path,
        import_sources: [
          {
            cue: 'Vadim Repin (violin), Valery Gergiev & Kirov Orchestra - Tchaikovsky & Myaskovsky Violin Concertos.cue',
            file: 'Vadim Repin (violin), Valery Gergiev & Kirov Orchestra - Tchaikovsky & Myaskovsky Violin Concertos.flac',
            albums: [
              {
                artist: 'Чайковский',
                title: 'Violin Concerto In D Major, Op.35',
                year: '1878',
                cover: '',
                tracks: [
                  {number: '1', title: 'I. Allegro Moderato', cue_track: '1'},
                  {number: '2', title: 'II. Canzonetta', cue_track: '2'},
                  {number: '3', title: 'III. Finale: Allegro vivacissimo', cue_track: '3'}
                ]
              },
              {
                artist: 'Мясковский',
                title: 'Violin Concerto In D Minor, Op.44',
                year: '1938',
                cover: '',
                tracks: [
                  {number: '1', title: 'I. Allegro', cue_track: '4'},
                  {number: '2', title: 'II. Adagio E Molto Cantabile', cue_track: '5'},
                  {number: '3', title: 'III. Allegro Molto—Allegro. Scherzoso', cue_track: '6'}
                ]
              }
            ]
          }
        ]
      }
    end

    it 'creates two albums with given tracks' do
      skip
      expect(Album.find_by(title: 'Violin Concerto In D Minor, Op.44')).to be_persisted
    end

    it 'removes splitted files' do
      skip
      splitted_files = Dir.glob('Vadim Repin (violin), Valery Gergiev & Kirov Orchestra - Tchaikovsky & Myaskovsky Violin Concertos - *.flac', base: path)
      expect(splitted_files).to be_empty
    end
  end
end
