module Tracklist::Representer
  class Show < BaseRepresenter
    property :id
    property :name
    collection :tracks, decorator: ::Track::Representer::Base
  end
end
