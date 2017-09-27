require 'rails_helper'

RSpec.describe Admin::MentorsController, type: :request do

  let(:auth_headers) do
    { "Authorization" => "Bearer #{@token}" }
  end

  let!(:record) { create(:user, :mentor)}

  context "as admin" do
    before do
      user = create(:user, :admin)
      @token = Knock::AuthToken.new(payload: user.to_token_payload).token
    end

    it "GET index" do
      get "/admin/mentors", headers: auth_headers
      expect(response.status).to eq 200
    end

    it "GET show" do
      get "/admin/mentors/#{record.id}", headers: auth_headers
      expect(response.status).to eq 200
    end

    it "POST create" do
      attributes = attributes_for(:user, :mentor).with_indifferent_access

      post "/admin/mentors", params: { user: attributes }, headers: auth_headers
      expect(response.status).to eq 201

      attributes.except(:password).each do |attr, val|
        expect(json[attr]).to eq val
      end
    end

    it "PUT update" do
      put "/admin/mentors/#{record.id}", params: { user: { name: "New Name" } }, headers: auth_headers
      expect(response.status).to eq 200
      expect(json["name"]).to eq "New Name"
    end

    it "DELETE destroy" do
      delete "/admin/mentors/#{record.id}", headers: auth_headers
      expect(response.status).to eq 204
    end
  end

  context "as mentor" do
    before do
      user = create(:user, :mentor)
      @token = Knock::AuthToken.new(payload: user.to_token_payload).token
    end

    it "does not GET index" do
      get "/admin/mentors", headers: auth_headers
      expect(response.status).to eq 401
    end

    it "does not GET show" do
      get "/admin/mentors/#{record.id}", headers: auth_headers
      expect(response.status).to eq 401
    end

    it "does not POST create" do
      post "/admin/mentors", params: attributes_for(:user, :mentor), headers: auth_headers
      expect(response.status).to eq 401
    end

    it "does not PUT update" do
      put "/admin/mentors/#{record.id}", params: { name: "New Name" }, headers: auth_headers
      expect(response.status).to eq 401
    end

    it "does not DELETE destroy" do
      delete "/admin/mentors/#{record.id}", headers: auth_headers
      expect(response.status).to eq 401
    end
  end

  context "as user" do
    before do
      user = create(:user)
      @token = Knock::AuthToken.new(payload: user.to_token_payload).token
    end

    it "does not GET index" do
      get "/admin/mentors", headers: auth_headers
      expect(response.status).to eq 401
    end

    it "does not GET show" do
      get "/admin/mentors/#{record.id}", headers: auth_headers
      expect(response.status).to eq 401
    end

    it "does not POST create" do
      post "/admin/mentors", params: attributes_for(:user, :mentor), headers: auth_headers
      expect(response.status).to eq 401
    end

    it "does not PUT update" do
      put "/admin/mentors/#{record.id}", params: { name: "New Name" }, headers: auth_headers
      expect(response.status).to eq 401
    end

    it "does not DELETE destroy" do
      delete "/admin/mentors/#{record.id}", headers: auth_headers
      expect(response.status).to eq 401
    end
  end

end
