class VirtualUser < ApplicationRecord
  validates :email, presence: true
  validates :birthdate, presence: true

  has_one :pokermon, class_name: "Sites::Pokermon", dependent: :destroy
end
