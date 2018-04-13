class Note::Index < BaseOperation
  step :model!

  private

  def model!(options, **)
    options[:model] = Note.all
  end
end
