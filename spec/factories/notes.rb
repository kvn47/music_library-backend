# == Schema Information
#
# Table name: notes
#
#  id            :integer          not null, primary key
#  type          :string
#  artist        :string
#  album         :string
#  download_url  :string
#  download_path :string
#  release_date  :date
#  details       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :note do
    kind 'listen'
    sequence(:artist) { |n| "Artist #{n}" }
    sequence(:album) { |n| "Album #{n}" }

    trait :download do
      download_url "MyString"
      download_path "MyString"
    end

    trait :await do
      release_date "2018-01-17"
    end
  end
end
