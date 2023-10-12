require "rails_helper"

RSpec.describe "Sessions", type: :request do
  fixtures :users
  let(:user) { users(:lazaro_nixon) }

  describe "GET #index" do
    it "returns HTTP success" do
      sign_in_as(user)

      get sessions_url

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "returns HTTP success" do
      get sign_in_url

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "with valid credentials" do
      it "signs the user in" do
        post sign_in_url, params: { email: user.email, password: "Secret1*3*5*" }
        expect(response).to redirect_to(root_url)

        get root_url
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid credentials" do
      it "does not sign the user in" do
        post sign_in_url, params: { email: user.email, password: "SecretWrong1*3" }
        expect(response).to redirect_to(sign_in_url(email_hint: user.email))

        get root_url
        expect(response).to redirect_to(sign_in_url)
      end
    end
  end

  describe "DELETE #destroy" do
    it "signs the user out" do
      sign_in_as(user)

      delete session_url(user.sessions.last)
      expect(response).to redirect_to(sessions_url)

      follow_redirect!
      expect(response).to redirect_to(sign_in_url)
    end
  end
end
