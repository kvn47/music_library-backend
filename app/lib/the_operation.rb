require "dry/monads/result"
require "dry/matcher"
require "dry/matcher/result_matcher"

module TheOperation
  def self.included(base)
    base.class_eval do
      extend ClassMethods
      include Dry::Monads::Result::Mixin
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)
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
