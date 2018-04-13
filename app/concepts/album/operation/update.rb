class Album::Update < BaseOperation
  class Present < BaseOperation
    step Model(Album, :find_by)
    step Contract::Build(constant: Album::Contract::Base)
  end

  step Nested(Present)
  step Contract::Validate(key: :album)
  step Contract::Persist()
end