class UpdateSettings < ATransaction
  step :save

  def save(params:, **)
    # TODO: check path in contract
    MusicLibrary.config[:library_path] = params[:library_path]
  end
end
