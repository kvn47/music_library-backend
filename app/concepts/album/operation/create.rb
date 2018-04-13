class Album::Create < BaseOperation
  class Present < BaseOperation
    step Model(Album, :new)
    step ->(_options, model:, params:, **) { model.artist_id = params[:artist_id] }
    step Contract::Build(constant: Album::Contract::Base)
  end

  step Nested(Present)
  step Contract::Validate(key: :album)
  step Contract::Persist()
end