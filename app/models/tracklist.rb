# == Schema Information
#
# Table name: tracklists
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tracklist < ApplicationRecord
  scope :ordered, -> { order :name }
  has_and_belongs_to_many :tracks, join_table: 'tracklistings'
end
