require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) { users(:lazaro_nixon) }
  let(:token) { sign_in_as(user) }
  let(:default_headers) { { "Authorization" => "Bearer #{token}" } }

  describe "GET #index" do
    it "returns HTTP success" do
      get sessions_url, headers: default_headers

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns HTTP success" do
      get session_url(user.sessions.last), headers: default_headers

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "with valid credentials" do
      it "returns HTTP created" do
        post sign_in_url, params: { email: user.email, password: "Secret1*3*5*" }

        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid credentials" do
      it "returns HTTP unauthorized" do
        post sign_in_url, params: { email: user.email, password: "SecretWrong1*3" }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE #destroy" do
    it "returns HTTP no content" do
      delete session_url(user.sessions.last), headers: default_headers

      expect(response).to have_http_status(:no_content)
    end
  end
end
