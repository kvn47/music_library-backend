class FindWorkInfo < ATransaction
  step :perform

  private

  def perform(title:, artist:, **)
    mb_client = MusicBrainzClient.new
    work_info = mb_client.work(title: title, artist: artist)
    return Failure('Work not found') if work_info.nil?

    Success work_info
  end
end
