# == Schema Information
#
# Table name: notes
#
#  id            :integer          not null, primary key
#  kind          :string
#  artist        :string
#  album         :string
#  download_url  :string
#  download_path :string
#  release_date  :date
#  details       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Note < ApplicationRecord
  KINDS = %w[listen download keep await].freeze

  scope :ordered, -> { order :created_at }

  def self.query(search: nil, **)
    notes = ordered

    if search
      search.chomp.split(/\s+/).each do |word|
        notes = notes.where('LOWER(artist) ILIKE :search OR LOWER(album) ILIKE :search',
                            search: "%#{word.mb_chars.downcase}%")
      end
    end

    notes
  end
end
