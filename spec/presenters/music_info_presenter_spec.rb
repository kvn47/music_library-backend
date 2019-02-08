require 'rails_helper'

RSpec.describe MusicInfoPresenter do
  # subject { described_class.represent(music_info) }
  subject { described_class.new(music_info) }

  let(:music_info) do
    {
      images: ['cover.jpg'],
      albums: [
        {
          title: 'Violin Concerto in A minor, Op.82',
          artist: 'Глазунов',
          album_artist: nil,
          genre: 'Classical',
          year: 2004,
          cover: nil,
          tracks: [
            {
              number: 1,
              title: 'I. Moderato',
              file: '1. I. Moderato.flac'
            },
            {
              number: 2,
              title: 'II. Andante',
              file: '2. II. Andante.flac'
            },
            {
              number: 3,
              title: 'III. Allegro',
              file: '3. III. Allegro.flac'
            },
          ]
        }
      ]
    }
  end

  it do
    presented = MusicInfoPresenter.represent(music_info)
    presented
    # is_expected.to represent(:images)
  end
end
