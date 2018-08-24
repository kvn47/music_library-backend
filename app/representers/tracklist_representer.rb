class TracklistRepresenter < ARepresenter
  property :id
  property :name
  collection :tracks, decorator: TrackRepresenter, if: ->(options:, **) { options[:version] == :full }
end
