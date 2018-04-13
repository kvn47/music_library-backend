class Setting::Update < BaseOperation
  step :save!

  def save!(_options, params:, **)
    # TODO: check path in contract
    MusicLibrary.config[:library_path] = params[:library_path]
  end
end