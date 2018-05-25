class PerformImport
  include Dry::Transaction

  map :process

  def process(albums:, **)
    results = {}

    albums.each do |album_params|
      result = ImportAlbum.new.(album_params)

      results.store album_params[:title],
                    result: result.success? ? 'success' : 'failure',
                    message: result.value
    end

    results
  end
end
