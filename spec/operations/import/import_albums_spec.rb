require 'rails_helper'

# RSpec.shared_examples 'importing album' do
#   it 'imports tracks in given album' do
#
#   end
# end

RSpec.describe Import::PerformImport, :import do
  subject(:result) { described_class.new.(import_params) }

  context 'one album from separate flac files' do
    let(:import_params) do
      [
        {
          path: '/Users/vova/Downloads/Music/Shinedown - 2018 - Attention Attention [FLAC] [CD]',
          albums: [
            {
              artist: 'Shinedown',
              title: 'ATTENTION ATTENTION',
              year: '2018',
              cover: '',
              tracks: [
                {number: '1', title: 'THE ENTRANCE', file: '01. THE ENTRANCE.flac'},
                {number: '2', title: 'DEVIL', file: '02. DEVIL.flac'},
                {number: '3', title: 'BLACK SOUL', file: '03. BLACK SOUL.flac'}
              ]
            }
          ]
        }
      ]
    end

    it { is_expected.to be_success }
  end

  context 'two albums from one flac file with cue' do
    let(:import_params) do
      [
        {
          path: '/Users/vova/Downloads/Music/Tchaikovsky, Myaskovsky - Violin Concertos - Repin, Gergiev',
          cue: 'Vadim Repin (violin), Valery Gergiev & Kirov Orchestra - Tchaikovsky & Myaskovsky Violin Concertos.cue',
          file: 'Vadim Repin (violin), Valery Gergiev & Kirov Orchestra - Tchaikovsky & Myaskovsky Violin Concertos.flac',
          albums: [
            {
              artist: 'Чайковский',
              title: 'Violin Concerto In D Major, Op.35',
              year: '1878',
              cover: '',
              tracks: [
                {number: '1', title: 'I. Allegro Moderato', cue_track: '01'},
                {number: '2', title: 'II. Canzonetta', cue_track: '02'},
                {number: '3', title: 'III. Finale: Allegro vivacissimo', cue_track: '03'}
              ]
            },
            {
              artist: 'Мясковский',
              title: 'Violin Concerto In D Minor, Op.44',
              year: '',
              cover: '',
              tracks: [
                {number: '1', title: 'I. Allegro', cue_track: '04'},
                {number: '2', title: 'II. Adagio E Molto Cantabile', cue_track: '05'},
                {number: '3', title: 'III. Allegro Molto—Allegro. Scherzoso', cue_track: '06'}
              ]
            }
          ]
        }
      ]
    end

    it 'creates two albums with given tracks' do
      # expect().
    end
  end
end
