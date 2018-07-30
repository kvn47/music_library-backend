module Callable
  def self.included(base)
    base.class_eval do
      extend ClassMethods
    end
  end

  module ClassMethods
    def call(**input)
      new.(input)
    end
  end

  def call(**)
    raise NotImplementedError, 'override me'
  end
end
