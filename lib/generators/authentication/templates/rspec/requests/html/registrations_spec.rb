require "rails_helper"

RSpec.describe "Registrations", type: :request do
  describe "GET #new" do
    it "returns HTTP success" do
      get sign_up_url

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "creates a new user" do
      expect {
        post sign_up_url, params: { email: "lazaronixon@hey.com", password: "Secret1*3*5*", password_confirmation: "Secret1*3*5*" }
      }.to change{ User.count }.by(1)

      expect(response).to redirect_to(root_url)
    end
  end
end
