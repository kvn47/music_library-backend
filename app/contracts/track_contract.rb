TrackContract = Dry::Validation.JSON(ASchema) do
  required(:number).filled(:int?)
  required(:title).filled
  required(:album_id).filled(:int?)
end
