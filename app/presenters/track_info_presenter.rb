class TrackInfoPresenter < Grape::Entity
  expose :number
  expose :title
  expose :cue_track
  expose :file
  expose :mb_length
  expose :mb_id
  expose :mb_title
  expose :mb_url
end
