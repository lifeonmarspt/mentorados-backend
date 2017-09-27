require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  before do
    @user = create(:user, password: "hunter2")
  end

  it "logs in user with valid credentials" do
    post "/sessions", params: { session: { email: @user.email, password: "hunter2" } }
    expect(response.status).to eq 201
    expect(json["jwt"]).to be_present
  end

  it "does not log in user with invalid credentials" do
    post "/sessions", params: { session: { email: @user.email, password: "nothunter2" } }
    expect(response.status).to eq 401
  end
end
