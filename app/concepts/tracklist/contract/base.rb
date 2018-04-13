module Tracklist::Contract
  class Base < BaseContract
    property :name

    validation do
      required(:name).filled
    end
  end
end
