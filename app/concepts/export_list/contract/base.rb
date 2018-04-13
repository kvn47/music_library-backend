module ExportList::Contract
  class Base < BaseContract
    properties :name, :capacity, :destination_path

    validation do
      required(:name).filled
      optional(:capacity).maybe(:int?)
    end
  end
end