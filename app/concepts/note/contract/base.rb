module Note::Contract
  class Base < BaseContract
    properties :kind, :details, :artist, :album, :download_url, :download_path, :release_date

    validation do
      optional(:kind).maybe(:str?, included_in?: Note::KINDS)
      optional(:details).maybe(:str?)
      optional(:artist).maybe(:str?)
      optional(:album).maybe(:str?)
      optional(:download_url).maybe(:str?)
      optional(:download_path).maybe(:str?)
      optional(:release_date).maybe(:date?)
    end
  end
end
