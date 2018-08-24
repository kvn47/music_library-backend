class NoteRepresenter < ARepresenter
  property :id
  property :kind
  property :artist
  property :album
  property :download_url
  property :download_path
  property :release_date
  property :details, if: ->(options:, **) { options[:version] == :full }
end
