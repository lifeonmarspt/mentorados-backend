class WelcomerMailer < ApplicationMailer

  def welcome(mentor)
    @mentor = mentor
    @confirmation_url = mentor.confirmation_token
    mail to: "#{mentor.name} <#{mentor.email}>"
  end

end
