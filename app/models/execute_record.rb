class ExecuteRecord < ApplicationRecord
  scope :of_email, ->(email) {
    where(email: email)
  }

  scope :for_action, ->(action) {
    where(action: action)
  }
end
