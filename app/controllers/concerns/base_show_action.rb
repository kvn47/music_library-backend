module BaseShowAction
  def show
    model = model_class.find_by(id: params[:id])
    model ? represent(model, version: :full) : render_error(:record_not_found)
  end
end
