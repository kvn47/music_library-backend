class TracklistPresenter < Grape::Entity
  expose :id
  expose :name
  expose :tracks, with: TrackPresenter, if: { type: :full }
end
