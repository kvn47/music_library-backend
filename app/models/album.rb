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
  scope :ordered, -> { order year: :desc }
  scope :by_artist_id, ->(artist_id) { where artist_id: artist_id }
  belongs_to :artist, optional: true
  has_many :tracks, dependent: :destroy
  delegate :name, to: :artist, prefix: true, allow_nil: true
  mount_uploader :cover, ImageUploader

  def self.query(artist_id:, **)
    albums = artist_id ? by_artist_id(artist_id) : all
    albums.ordered
  end

  def cover_thumb_url
    cover.thumb.url
  end
end
