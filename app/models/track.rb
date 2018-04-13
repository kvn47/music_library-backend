# == Schema Information
#
# Table name: tracks
#
#  id         :integer          not null, primary key
#  number     :integer          not null
#  title      :string           not null
#  path       :string
#  size       :integer
#  album_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  length     :integer
#

class Track < ApplicationRecord
  scope :ordered, -> { order :number }
  scope :in_export_list, ->(export_list) { where id: export_list.track_ids }
  belongs_to :album
  has_and_belongs_to_many :tracklists, join_table: 'tracklistings'
  delegate :title, to: :album, prefix: true
  delegate :artist, to: :album
  delegate :name, to: :artist, prefix: true
end
