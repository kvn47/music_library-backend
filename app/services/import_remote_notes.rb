module ImportRemoteNotes
  def self.call
    RemoteNote.find_each do |remote_note|
      unless Note.exists?(artist: remote_note.artist, album: remote_note.album)
        Note.create!(remote_note.attributes.except('id'))
      end
    end
  end
end
