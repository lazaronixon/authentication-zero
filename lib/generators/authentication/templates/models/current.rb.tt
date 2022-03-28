class Current < ActiveSupport::CurrentAttributes
  attribute :session, :user
  attribute :user_agent, :ip_address

  def session=(session)
    super; self.user = session.user
  end
end
