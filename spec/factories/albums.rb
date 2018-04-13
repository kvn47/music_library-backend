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

FactoryBot.define do
  factory :album do
    sequence(:title) { |n| "Album #{n}" }
  end
end
