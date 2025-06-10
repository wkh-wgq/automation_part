class ApplicationMailbox < ActionMailbox::Base
  delegate :logger, to: :Rails
  # routing /something/i => :somewhere
  routing all: :pokermon_register
end
