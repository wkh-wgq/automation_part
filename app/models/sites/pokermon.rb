class Sites::Pokermon < ApplicationRecord
  belongs_to :virtual_user

  validates :registry_cellphone, :registry_postcode, :registry_fandi, :reg_password, presence: true
end
