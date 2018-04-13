class Tracklist::Show < BaseOperation
  step :model!
  failure :record_not_found!

  private

  def model!(options, params:, **)
    options[:model] = Tracklist.includes(:tracks).find_by(id: params[:id])
  end
end
