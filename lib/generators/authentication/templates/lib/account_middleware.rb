class AccountMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)

    _, account_id, request_path = request.path.split("/", 3)

    if is_integer?(account_id)
      set_current_account(account_id)

      request.script_name = "/#{account_id}"
      request.path_info   = "/#{request_path}"
      @app.call(request.env)
    else
      @app.call(request.env)
    end
  end

  private
    def is_integer?(value)
      Integer(value, exception: false)
    end

    def set_current_account(account_id)
      Current.account = Account.find(account_id)
    end
end
