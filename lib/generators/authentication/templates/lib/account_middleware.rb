class AccountMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)

    if m = /\A(\/(\d{1,}))/.match(request.path_info)
      script_name, account_id, path_info = [m[1], m[2], m.post_match]
      request.script_name = script_name
      request.path_info   = path_info.presence || "/"
      set_current_account(account_id)
      @app.call(request.env)
    else
      @app.call(request.env)
    end
  end

  private
    def set_current_account(account_id)
      Current.account = Account.find(account_id)
    end
end
