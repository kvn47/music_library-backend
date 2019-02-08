require 'rails_helper'

RSpec.describe ToolsAPI do
  describe "GET collect_info" do
    subject! { get '/api/collect_info', params: {path: ''} }

    include_examples "successful response"

    it "returns music info" do
      expect(response.body).to include_json(:albums)
    end
  end
end
