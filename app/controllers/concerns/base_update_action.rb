module BaseUpdateAction
  def update
    run UpdateModel, step_args: {validate: [contract], update: [model_class, params[:id]]}
  end
end
