TracklistContract = ASchema.define do
  class Base < BaseContract
    property :name

    validation do
      required(:name).filled
    end
  end
end
