module AccountScoped
  extend ActiveSupport::Concern

  included do
    belongs_to :account

    default_scope do
      where(account: Current.account || raise("You must set an account"))
    end
  end
end
