require 'representable/json'

class ARepresenter < Representable::Decorator
  include Representable::JSON
end