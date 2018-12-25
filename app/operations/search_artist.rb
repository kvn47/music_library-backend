class SearchArtist < ATransaction
  map :perform

  private

  def perform(name:, **)
    mb_client = MusicBrainzClient.new
    mb_client.search_artist(name: name)
  end
end
