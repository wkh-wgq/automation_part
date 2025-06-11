module BrowserAutomation
  module Pokermon
    def self.send_register_email(email)
      Pokermon::RegisterRunner.new(email: email).send_email
    end

    def self.register(email, register_link, name:, jp_name:, birthday:, gender:, postal_code:, street_number:, password:, mobile:)
      Pokermon::RegisterRunner.new(email: email).register(
        register_link: register_link,
        name: name,
        jp_name: jp_name,
        birthday: birthday,
        gender: gender,
        postal_code: postal_code,
        street_number: street_number,
        password: password,
        mobile: mobile
      )
    end
  end
end
