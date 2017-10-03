require 'rails_helper'


RSpec.describe MentorsController, type: :request do
  let(:auth_headers) do
    token = user && Knock::AuthToken.new(payload: user.to_token_payload).token
    { "Authorization" => "Bearer #{token}" }
  end

  def controller_params(params)
    ActionController::Parameters.new(params).permit(:string, career_ids: [], trait_ids: [])
  end

  context "logged in" do
    let(:user) { create(:user) }

    context "GET index" do
      before do
        @mentor = create(:user, :mentor)
        allow(User).to receive(:search).and_return([@mentor])
      end

      it "is authorized" do
        get "/mentors", headers: auth_headers
        expect(response.status).to eq 200
      end

      it "returns the results of User.search" do
        get "/mentors", headers: auth_headers
        expect(json.first[:id]).to eq @mentor.id
      end

      it "returns all mentors if no filters given" do
        filter_params = {}

        get "/mentors", headers: auth_headers, params: filter_params
        expect(User).to have_received(:search).with(controller_params(filter_params))
      end

      it "receives career_ids" do
        filter_params = { career_ids: %w(0 1) }

        get "/mentors", headers: auth_headers, params: filter_params
        expect(User).to have_received(:search).with(controller_params(filter_params))
      end

      it "receives trait_ids" do
        filter_params = { trait_ids: %w(0 1) }

        get "/mentors", headers: auth_headers, params: filter_params
        expect(User).to have_received(:search).with(controller_params(filter_params))
      end

      it "receives string" do
        filter_params = { string: "yup" }

        get "/mentors", headers: auth_headers, params: filter_params
        expect(User).to have_received(:search).with(controller_params(filter_params))
      end

      it "receives string and career_ids and trait_ids" do
        filter_params = { string: "yup", trait_ids: %w(1), career_ids: %w(1 2) }

        get "/mentors", headers: auth_headers, params: filter_params
        expect(User).to have_received(:search).with(controller_params(filter_params))
      end
    end
  end

  context "logged out" do
    let(:user) { nil }

    it "does not GET index" do
      get "/mentors", headers: auth_headers
      expect(response.status).to eq 401
    end
  end
end
