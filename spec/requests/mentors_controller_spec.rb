require 'rails_helper'

RSpec.describe MentorsController, type: :request do
  let(:auth_headers) do
    { "Authorization": "Bearer #{@token}" }
  end

  context "logged in" do
    before do
      user = create(:user)
      @token = Knock::AuthToken.new(payload: user.to_token_payload).token
    end

    it "GET index" do
      get "/mentors", headers: auth_headers
      expect(response.status).to eq 200
    end

    it "GET index with filters" do
      # spied = spy(User)
      allow(User).to receive(:search)

      get "/mentors", headers: auth_headers, params: { career_ids: %w(0 1) }
      params = ActionController::Parameters.new(career_ids: %w(0 1))
      query = params.permit(:string, career_ids: [], trait_ids: [])
      expect(User).to have_received(:search).with(query)

      get "/mentors", headers: auth_headers, params: { career_ids: %w(0), trait_ids: %w(1 3) }
      params = ActionController::Parameters.new(career_ids: %w(0), trait_ids: %w(1 3))
      query = params.permit(:string, career_ids: [], trait_ids: [])
      expect(User).to have_received(:search).with(query)

      get "/mentors", headers: auth_headers, params: { string: "test", trait_ids: %w(1 3) }
      params = ActionController::Parameters.new(string: "test", trait_ids: %w(1 3))
      query = params.permit(:string, career_ids: [], trait_ids: [])
      expect(User).to have_received(:search).with(query)
    end
  end

  context "logged out" do
    before { @token = nil }

    it "does not GET index" do
      get "/mentors", headers: auth_headers
      expect(response.status).to eq 401
    end
  end
end
