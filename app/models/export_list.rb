# == Schema Information
#
# Table name: export_lists
#
#  id               :integer          not null, primary key
#  name             :string           not null
#  size             :integer          default(0), not null
#  capacity         :integer
#  destination_path :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ExportList < ApplicationRecord
  scope :ordered, -> { order :name }
  has_and_belongs_to_many :tracks, join_table: 'tracks_exports'
  has_many :tracklists, through: :tracks

  def fullness
    return 0 if capacity.nil?
    ((size.to_f / capacity.gigabytes) * 100).round
  end

  def update_size
    tracks_size = tracks.sum :size
    update size: tracks_size
  end
end
