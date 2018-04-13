require 'reform/form/dry'

class BaseContract < Reform::Form
  include Dry
  # include Reform::Form::ActiveModel::ModelReflections
end