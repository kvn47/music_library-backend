require 'representable/json'

module Track::Representer
  class Base < Representable::Decorator
    include Representable::JSON
    include ActiveSupport::NumberHelper

    property :id
    property :title
    property :number
    property :size, exec_context: :decorator

    def size
      number_to_human_size represented.size
    end
  end
end