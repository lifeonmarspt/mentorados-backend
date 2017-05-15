class WelcomerMailer < ApplicationMailer

  def welcome(mentor)
    @mentor = mentor
    @confirmation_url = "#{ENV["FRONTEND_URL"]}/users/#{mentor.id}/confirm/#{mentor.confirmation_token}"
    mail to: mentor.email
  end

end
