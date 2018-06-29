module ExportList::Representer
  class Show < Base
    include ActiveSupport::NumberHelper

    collection :tracks, decorator: ::Track::Representer::Base
  end
end