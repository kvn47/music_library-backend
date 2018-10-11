module BaseDestroyAction
  def destroy
    run DestroyModel, step_args: {destroy: [model_class]}
  end
end
