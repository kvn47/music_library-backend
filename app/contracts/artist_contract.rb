ArtistContract = Dry::Validation.JSON(ASchema) do
  required(:name).filled
end
