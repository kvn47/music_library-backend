class TrackInfoPresenter < Grape::Entity
  expose :number
  expose :title
  expose :cue_track
  expose :file
  expose :mb_length
  expose :mbid
  expose :mb_url
end
