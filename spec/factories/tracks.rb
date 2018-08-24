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

FactoryBot.define do
  factory :track do
    sequence(:number) { |n| n }
    title { "Track #{number}" }
  end
end
