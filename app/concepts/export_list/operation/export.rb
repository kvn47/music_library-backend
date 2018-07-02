class ExportList::Export < BaseOperation
  step Model(ExportList, :find_by)
  step :process!
  step :result_message!

  def process!(_, model:, params:, **)
    destination_path = params['destination_path']
    return false if destination_path.blank?

    model.tracks.each do |track|
      dest = File.join destination_path, track.artist_name, track.album_title
      FileUtils.mkdir_p dest
      FileUtils.cp track.path, dest
    end
  end

  def result_message!(options, **)
    options['result.message'] = 'Export accomplished.'
  end

  def create_playlists!(model:, params:, **)
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
