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

    context "filters mentors" do
      it "by careers"
      it "by traits"
      it "by search"
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
