class ParsedEmailRecord < ApplicationRecord
  self.inheritance_column = :no_need

  belongs_to :inbound_email, class_name: "ActionMailbox::InboundEmail"
end
