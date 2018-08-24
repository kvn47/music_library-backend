class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.query(**)
    all
  end
end
