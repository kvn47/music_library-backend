module BaseIndexAction
  def index
    collection = model_class.query(**action_params)
    represent collection
  end
end
