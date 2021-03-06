class AutoImport < ATransaction
  step :collect_info
  step :process

  private

  def collect_info(path:, **)
    result = CollectInfo.(path: path)

    if result.success?
      Success path: path, import_sources: result.value
    else
      Failure result.value
    end
  end

  def process(input)
    ImportMusic.(input)
  end
end
