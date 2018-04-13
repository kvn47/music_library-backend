class Tracklist::Index < BaseOperation
  step :model!

  private

  def model!(options, **)
    options[:model] = Tracklist.ordered
  end
end
