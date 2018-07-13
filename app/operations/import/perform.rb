module Import
  class Perform
    include Dry::Transaction

    map :prepare
    map :process

    private

    def prepare(input)

    end

    def process(albums:, **)
      results = {}

      albums.each do |album_params|
        result = ProcessAlbum.new.(album_params)

        results.store album_params[:title],
                      result: result.success? ? 'success' : 'failure',
                      message: result.value
      end

      results
    end
  end
end
