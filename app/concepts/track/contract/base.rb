module Track::Contract
  class Base < BaseContract
    properties :number, :title, :album_id

    validation do
      required(:number).filled
      required(:title).filled
      required(:album_id).filled
    end
  end
end