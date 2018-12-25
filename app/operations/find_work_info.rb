class FindWorkInfo < ATransaction
  step :perform

  private

  def perform(title:, artist:, artist_mbid: nil, **)
    mb_client = MusicBrainzClient.new
    work_info = mb_client.work(title: title, artist: artist, artist_mbid: artist_mbid)
    return Failure('Work not found') if work_info.nil?

    Success work_info
  end
end
