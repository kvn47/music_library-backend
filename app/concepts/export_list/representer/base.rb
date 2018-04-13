module ExportList::Representer
  class Base < BaseRepresenter
    include ActiveSupport::NumberHelper

    property :id
    property :name
    property :destination_path
    property :capacity
    property :size
    property :created_at
    property :updated_at
  end
end