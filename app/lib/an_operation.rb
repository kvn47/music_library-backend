require "dry/monads/result"
require "dry/matcher"
require "dry/matcher/result_matcher"

module AnOperation
  def self.included(base)
    base.class_eval do
      # include Callable
      include Dry::Monads::Result::Mixin
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)
    end
  end
end
