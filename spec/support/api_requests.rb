RSpec.shared_examples "successful response" do
  it "has http status 200 (ok)" do
    expect(response).to have_http_status(:ok), "[#{response.status}] #{response.body}"
  end
end

RSpec.shared_examples "successful create response" do
  it "has http status 201 (created)" do
    expect(response).to have_http_status(:created), "[#{response.status}] #{response.body}"
  end
end
