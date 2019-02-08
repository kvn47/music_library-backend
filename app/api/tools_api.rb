# frozen_string_literal: true

class ToolsAPI < Grape::API
  desc 'Collect info'
  params do
    requires :path, type: String
    optional :collect_mb_info, type: Boolean, default: false
    optional :artist, type: String
    optional :album, type: String
  end
  get 'collect_info' do
    run_operation CollectInfo do |m|
      m.success { |result| present(result, with: MusicInfoPresenter) }
      m.failure(&method(:present_error))
    end
  end

  desc 'Find work info'
  get 'find_work_info' do
    run_operation FindWorkInfo do |m|
      m.success { |result| present(result, with: WorkInfoPresenter) }
      m.failure(&method(:present_error))
    end
  end

  desc 'Search artist'
  params do
    requires :name, type: String
  end
  get 'search_artist' do
    artists = MusicBrainzClient.new.search_artist(name: params[:name])
    present artists
  end

  desc 'Organize files'
  post 'organize_files' do
    run_operation OrganizeAlbumFiles do |m|
      m.success { |_| status(:ok) }
      m.failure(&method(:present_error))
    end
  end
end
