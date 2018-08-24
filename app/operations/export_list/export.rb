class ExportList::Export < ATransaction
  try :find_export_list, catch: ActiveRecord::RecordNotFound
  step :process

  private

  def find_export_list(id:, **params)
    export_list = ExportList.find(id)
    params.merge export_list: export_list
  end

  def process(export_list:, **params)
    destination_path = params.fetch(:destination_path, export_list.destination_path)
    return Failure(:no_destination) if destination_path.blank?

    export_list.tracks.each do |track|
      dest = File.join(destination_path, track.artist_name, track.album_title)
      FileUtils.mkdir_p dest
      FileUtils.cp track.path, dest
    end
  end

  def create_playlists(model:, params:, **)
    destination_path = params['destination_path']
    tracklists = model.tracklists

    tracklists.each do |tracklist|
      tracks = tracklist.tracks.in_export_list(model)
      create_playlist_file "#{destination_path}/#{tracklist.name}", tracks

      tracks.group_by(&:artist_name).each do |artist_name, artist_tracks|
        create_playlist_file "#{destination_path}/#{artist_name}/#{tracklist.name}", artist_tracks

        artist_tracks.group_by(&:album_title).each do |album_title, album_tracks|
          create_playlist_file "#{destination_path}/#{artist_name}/#{album_title}/#{tracklist.name}", album_tracks
        end
      end
    end
  end

  def create_playlist_file(path, tracks)
    data = '#EXTM3U\n'

    tracks.each do |track|
      length = track.length || -1
      data << "#EXTINF:#{length},#{track.artist_name} - #{track.title}\n"
      path = track.path
      data << "#{path}\n"
    end

    tracklist_path = "#{path}.m3u8"
    File.open(tracklist_path, 'w') { |file| file.write data }
  end
end
