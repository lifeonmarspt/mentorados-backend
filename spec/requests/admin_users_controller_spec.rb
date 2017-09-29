require 'rails_helper'

RSpec.describe Admin::UsersController, type: :request do

  let(:auth_headers) do
    { "Authorization": "Bearer #{@token}"}
  end

  let!(:record) { create(:user) }

  context "as admin" do
    before do
      user = create(:user, :admin)
      @token = Knock::AuthToken.new(payload: user.to_token_payload).token
    end

    it "GET index" do
      get "/admin/users", headers: auth_headers
      expect(response.status).to eq 200
    end

    it "GET show" do
      get "/admin/users/#{record.id}", headers: auth_headers
      expect(response.status).to eq 200
    end

    it "POST create" do
      UserMailer.any_instance.stub_chain(:welcome, :deliver_now)
      attributes = attributes_for(:user)

      post "/admin/users", params: { user: attributes }, headers: auth_headers
      expect(response.status).to eq 201

      attributes.except(:password, :name, :active).each do |attr, val|
        expect(json[attr]).to eq val
      end
    end

    it "PUT update" do
      put "/admin/users/#{record.id}", params: { user: { email: "new@email.com" } }, headers: auth_headers
      expect(response.status).to eq 200
      expect(json["email"]).to eq "new@email.com"
    end

    it "DELETE destroy" do
      delete "/admin/users/#{record.id}", headers: auth_headers
      expect(response.status).to eq 204
    end
  end

  context "as user" do
    before do
      user = create(:user)
      @token = Knock::AuthToken.new(payload: user.to_token_payload).token
    end

    it "does not GET index" do
      get "/admin/users", headers: auth_headers
      expect(response.status).to eq 401
    end

    it "does not GET show" do
      get "/admin/users/#{record.id}", headers: auth_headers
      expect(response.status).to eq 401
    end

    it "does not POST create" do
      post "/admin/users", params: { user: attributes_for(:user) }, headers: auth_headers
      expect(response.status).to eq 401
    end

    it "does not PUT update" do
      put "/admin/users/#{record.id}", params: { user: { name: "New Name" } }, headers: auth_headers
      expect(response.status).to eq 401
    end

    it "does not DELETE destroy" do
      delete "/admin/users/#{record.id}", headers: auth_headers
      expect(response.status).to eq 401
    end
  end
end
