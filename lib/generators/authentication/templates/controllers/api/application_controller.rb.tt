class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :set_current_request_details
  before_action :authenticate

  private
    def authenticate
      if session_record = authenticate_with_http_token { |token, _| Session.find_signed(token) }
        Current.session = session_record
      else
        request_http_token_authentication
      end
    end

    def set_current_request_details
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip
    end
end
