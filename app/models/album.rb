# == Schema Information
#
# Table name: albums
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  year       :integer
#  path       :string
#  cover      :string
#  artist_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Album < ApplicationRecord
  default_scope -> { ordered }
  scope :ordered, -> { order year: :desc }
  belongs_to :artist, optional: true
  has_many :tracks, dependent: :destroy
  delegate :name, to: :artist, prefix: true, allow_nil: true
  mount_uploader :cover, ImageUploader

  def cover_thumb_url
    cover.thumb.url
  end
end
