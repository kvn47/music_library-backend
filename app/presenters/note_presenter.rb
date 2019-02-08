class NotePresenter < Grape::Entity
  expose :id
  expose :kind
  expose :artist
  expose :album
  expose :download_url
  expose :download_path
  expose :release_date
  expose :details, if: { type: :full }
end
