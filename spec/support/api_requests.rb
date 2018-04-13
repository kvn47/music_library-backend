# require 'devise/jwt/test_helpers'
#
# RSpec.shared_context 'with json headers' do
#   let(:headers) { {'Accept': 'application/json', 'Content-Type': 'application/json'} }
# end
#
# RSpec.shared_context 'with authenticated user', json: true do
#   let(:current_user) { create :user }
#
#   let(:auth_headers) { Devise::JWT::TestHelpers.auth_headers headers, current_user }
# end
#
# RSpec.configure do |config|
#   config.include_context 'with authenticated user', auth: :user
#   config.include_context 'with json headers', json: true
# end
