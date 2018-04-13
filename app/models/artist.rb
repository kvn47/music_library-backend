# == Schema Information
#
# Table name: artists
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  path       :string
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Artist < ApplicationRecord
  default_scope -> { ordered }
  scope :ordered, -> { order :name }
  has_many :albums, dependent: :destroy
  has_many :tracks, through: :albums
  mount_uploader :image, ImageUploader

  def image_thumb_url
    image.thumb.url
  end
end
