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
end
