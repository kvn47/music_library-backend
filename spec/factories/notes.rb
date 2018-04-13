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
    type ""
    artist "MyString"
    album "MyString"
    download_url "MyString"
    download_path "MyString"
    release_date "2018-01-17"
    details "MyText"
  end
end
