# frozen_string_literal: true

class MusicBrainzAPI < Grape::API
  desc 'Find work info in MusicBrainz'
  params do
    requires :title, type: String
    requires :artist, type: String
    optional :artist_mb_id, type: String
  end
  get 'work_info' do
    run_operation FindWorkInfo do |m|
      m.success { |result| present(result, with: WorkInfoPresenter) }
      m.failure(&method(:present_error))
    end
  end

  desc 'Search artist in MusicBrainz'
  params do
    requires :name, type: String
  end
  get 'mb_artists' do
    artists = MusicBrainzClient.new.search_artist(name: params[:name])
    present artists
  end
end
