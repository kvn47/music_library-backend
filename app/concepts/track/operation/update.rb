class Track::Update < BaseOperation
  class Present < BaseOperation
    step Model(Track, :find_by)
    step Contract::Build(constant: Track::Contract::Base)
  end

  step Nested(Present)
  step Contract::Validate(key: :track)
  step Contract::Persist()
end