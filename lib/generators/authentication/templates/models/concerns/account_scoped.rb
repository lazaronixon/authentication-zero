module AccountScoped
  extend ActiveSupport::Concern

  included do
    belongs_to :account    
    default_scope { where account: Current.account }
  end
end
