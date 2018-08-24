class Tracklist::Clear < BaseOperation
  step :find_tracklist
  step :process

  private

  def find_tracklist(id:, **params)
    FindRecord.new.(model_class: Tracklist, id: id, **params)
  end

  def process(tracklist:, **)
    tracklist.tracks.clear
  end
end
