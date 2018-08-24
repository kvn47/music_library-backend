module AContract
  def self.define(&block)
    Dry::Validation.JSON ASchema, &block
  end
end
