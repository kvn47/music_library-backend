module Note::Representer
  class Base < BaseRepresenter
    property :id
    property :kind
    property :artist
    property :album

    property :details
    property :download_url
    property :download_path
    property :release_date
  end
end
