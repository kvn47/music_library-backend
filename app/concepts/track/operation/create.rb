class Track::Create < BaseOperation
  class Present < BaseOperation
    step Model(Track, :new)
    step ->(_options, model:, params:, **) { model.album_id = params[:album_id] }
    step Contract::Build(constant: Track::Contract::Base)
  end

  step Nested(Present)
  step Contract::Validate(key: :track)
  step Contract::Persist()
end