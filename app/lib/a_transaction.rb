module ATransaction
  def self.included(base)
    base.class_eval do
      include Callable
      include Dry::Transaction
    end
  end
end
