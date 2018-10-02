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
  default_scope -> { ordered }
  scope :ordered, -> { order :number }
  scope :in_export_list, ->(export_list) { where id: export_list.track_ids }
  scope :by_artist_id, ->(artist_id) { includes(:album).where(albums: {artist_id: artist_id}) }
  scope :by_album_id, ->(album_id) { where album_id: album_id }
  belongs_to :album
  has_and_belongs_to_many :tracklists, join_table: 'tracklistings'
  delegate :title, to: :album, prefix: true
  delegate :artist, to: :album
  delegate :name, to: :artist, prefix: true

  def self.query(artist_id: nil, album_id: nil, track_id: nil, **)
    return by_artist_id(artist_id) if artist_id
    return by_album_id(album_id) if album_id
    return where(id: track_id) if track_id
    none
  end
end
