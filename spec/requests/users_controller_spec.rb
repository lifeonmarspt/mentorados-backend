require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let(:auth_headers) do
    token = user && Knock::AuthToken.new(payload: user.to_token_payload).token
    { "Authorization" => "Bearer #{token}" }
  end

  let(:record) { create(:user, :mentor) }

  let!(:update_params) do
    { user: { name: "New Name" } }
  end

  context "logged in as mentor" do
    let(:user) { create(:user, :mentor) }

    it "GET me" do
      get "/users/me", headers: auth_headers
      expect(response.status).to eq 200
      expect(json["email"]).to eq user.email
    end

    it "GET show for self" do
      get "/users/#{user.id}", headers: auth_headers
      expect(response.status).to eq 200
    end

    it "does not GET show for other" do
      get "/users/#{record.id}", headers: auth_headers
      expect(response.status).to eq 401
    end

    it "does not POST create" do
      post "/users", headers: auth_headers
      expect(response.status).to eq 401
    end

    it "PUT update for self" do
      put "/users/#{user.id}", params: update_params, headers: auth_headers
      expect(response.status).to eq 200
      expect(json["name"]).to eq "New Name"
    end

    it "does not PUT update for others" do
      put "/users/#{record.id}", params: update_params, headers: auth_headers
      expect(response.status).to eq 401
    end
  end

  context "logged out" do
    let(:user) { nil }

    it "does not GET me" do
      get "/users/me", headers: auth_headers
      expect(response.status).to eq 404
    end

    it "does not GET show" do
      get "/users/#{record.id}"
      expect(response.status).to eq 401
    end

    it "POST create" do
      UserMailer.any_instance.stub_chain(:welcome, :deliver_now)

      post "/users/", params: { user: { email: "new@fe.up.pt" }}
      expect(response.status).to eq 201
    end

    it "does not POST create for non @fe.up.pt emails" do
      post "/users/", params: { user: { email: "new@not.fe.up.pt" }}
      expect(response.status).to eq 400
    end

    it "does not PUT update" do
      put "/users/#{record.id}"
      expect(response.status).to eq 401
    end
  end
end
