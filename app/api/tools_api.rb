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

  desc 'Organize files'
  params do
    requires :path, type: String
    optional :dst_path, type: String
    optional :copy_files, type: Boolean
    requires :source_infos, type: JSON

    # requires :source_infos, type: Array do
    #   optional :cue, type: String
    #   optional :file, type: String
    #   requires :albums, type: Array do
    #
    #   end
    # end
  end
  post 'organize_files' do
    run_operation OrganizeFiles do |m|
      m.success { |_| status(:ok) }
      m.failure(&method(:present_error))
    end
  end
end
