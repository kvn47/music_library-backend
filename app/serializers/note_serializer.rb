class NoteSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :kind, :artist, :album, :details, :release_date, :download_url, :download_path
end
