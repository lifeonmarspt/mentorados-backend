require 'rails_helper'

RSpec.describe PasswordRecoveryTokensController, type: :request do

  before do
    UserMailer.any_instance.stub_chain(:recovery, :deliver_now)

    @user = create(:user)
  end

  context "POST create" do
    it "recovers existing email" do
      post "/password_recovery_tokens", params: { password_recovery_token: { email: @user.email } }
      expect(response.status).to eq 201
    end

    it "does not recover inexistent email" do
      post "/password_recovery_tokens", params: { password_recovery_token: { email: "nope@nope.nope" } }
      expect(response.status).to eq 404
    end
  end

  context "GET show" do
    it "returns user for valid token" do
      token = Knock::AuthToken.new(payload: @user.to_token_payload).token
      get "/password_recovery_tokens/#{token}"
      expect(response.status).to eq 200
      expect(json[:user][:id]).to eq @user.id
    end

    it "does not return user for invalid token" do
      get "/password_recovery_tokens/abc"
      expect(response.status).to eq 404
    end
  end
end
