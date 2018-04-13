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

require 'rails_helper'

RSpec.describe Note, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
