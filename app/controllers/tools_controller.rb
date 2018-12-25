class ToolsController < ApplicationController
  def collect_info
    run CollectInfo do |m|
      m.success { |result| render json: result }
      m.failure(&method(:render_error))
    end
  end

  def find_work_info
    run FindWorkInfo do |m|
      m.success { |result| render json: result }
      m.failure(&method(:render_error))
    end
  end

  def search_artist
    artists = MusicBrainzClient.new.search_artist(name: params[:name])
    render json: artists
    # run SearchArtist do |m|
    #   m.success { |result| render json: result }
    #   m.failure(&method(:render_error))
    # end
  end

  def organize_files
    run OrganizeAlbumFiles do |m|
      m.success { |_| render json: {messages: 'ok'}, status: :ok }
      m.failure(&method(:render_error))
    end
  end
end
