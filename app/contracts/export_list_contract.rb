ExportListContract = Dry::Validation.JSON(ASchema) do
  required(:name).filled
  optional(:capacity).maybe(:int?)
  optional(:destination_path).maybe(:str?)
end
