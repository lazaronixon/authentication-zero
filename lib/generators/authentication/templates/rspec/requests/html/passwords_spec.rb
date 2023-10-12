require "rails_helper"

RSpec.describe "Passwords", type: :request do
  fixtures :users
  let(:user) { users(:lazaro_nixon) }

  before do
    sign_in_as(user)
  end

  describe "GET #edit" do
    it "returns HTTP success" do
      get edit_password_url

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH #update" do
    context "with correct password challenge" do
      it "updates the password" do
        patch password_url, params: { password_challenge: "Secret1*3*5*", password: "Secret6*4*2*", password_confirmation: "Secret6*4*2*" }

        expect(response).to redirect_to(root_url)
      end
    end

    context "with wrong password challenge" do
      it "returns an error" do
        patch password_url, params: { password_challenge: "SecretWrong1*3", password: "Secret6*4*2*", password_confirmation: "Secret6*4*2*" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to have_selector("li", text: /Password challenge is invalid/)
      end
    end
  end
end
