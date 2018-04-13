module Album::Contract
  class Base < BaseContract
    properties :title, :artist_id

    validation do
      required(:title).filled
    end
  end
end