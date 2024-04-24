class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name("info@guentherscher-foerderverein.de", "Förderverein Güntherscher Kindergarten e.V.")
  layout "mailer"
end
