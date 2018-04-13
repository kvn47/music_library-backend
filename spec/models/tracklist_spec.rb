# == Schema Information
#
# Table name: tracklists
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Tracklist, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
