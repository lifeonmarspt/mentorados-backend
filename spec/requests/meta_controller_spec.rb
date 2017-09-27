require 'rails_helper'

RSpec.describe MetaController, type: :request do
  let(:auth_headers) do
    { "Authorization" => "Bearer #{@token}" }
  end

  before do
    3.times { create(:career) }
    5.times { create(:trait) }
  end

  context "logged in" do
    before do
      user = create(:user)
      @token = Knock::AuthToken.new(payload: user.to_token_payload).token
    end

    it "GET index" do
      get "/meta", headers: auth_headers
      expect(response.status).to eq 200
    end

    it "returns all careers and traits" do
      get "/meta", headers: auth_headers

      expect(json["careers"].size).to eq 3
      expect(json["traits"].size).to eq 5
    end
  end

  context "logged out" do
    it "does not GET index" do
      get "/meta"
      expect(response.status).to eq 401
    end
  end

end
