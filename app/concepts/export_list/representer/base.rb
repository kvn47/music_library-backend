module ExportList::Representer
  class Base < BaseRepresenter
    include ActiveSupport::NumberHelper

    property :id
    property :name
    property :destination_path
    property :created_at
    property :updated_at
    property :fullness
    property :capacity, exec_context: :decorator
    property :size, exec_context: :decorator

    def capacity
      return I18n.t('export_list.capacity.unlimited') if represented.capacity.nil?
      number_to_human_size represented.capacity.gigabytes
    end

    def size
      number_to_human_size represented.size
    end
  end
end
