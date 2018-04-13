require 'representable/json'

class BaseRepresenter < Representable::Decorator
  include Representable::JSON
end