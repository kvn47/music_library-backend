class FindWorkInfo < ATransaction
  step :perform

  private

  def perform(title:, artist:, artist_mb_id: nil, **)
    mb_client = MusicBrainzClient.new
    work_info = mb_client.work(title: title, artist: artist, artist_mb_id: artist_mb_id)
    return Failure('Work not found') if work_info.nil?

    Success work_info
  end
end
