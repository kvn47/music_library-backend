# frozen_string_literal: true

class Library::Import < BaseOperation
  # TODO: add contract

  step :process!

  def process!(options, params:, **)
    results = {}

    params[:albums].each do |album_params|
      result = Album::Import.({params: album_params}, options)
      results.store album_params[:title],
                    result: result.success? ? 'success' : 'failure',
                    message: result['result.message']
    end

    options['result.message'] = results
  end
end
