class Note::Show < BaseOperation
  step :model!
  failure :record_not_found!

  private

  def model!(options, params:, **)
    options[:model] = Note.find_by(id: params[:id])
  end
end
