class RecoveryMailer < ApplicationMailer
  def recovery(mentor)
    @mentor = mentor
    @reset_url = "#{ENV["FRONTEND_URL"]}/users/#{mentor.id}/reset/#{mentor.password_reset_token}"

    mail to: mentor.email
  end
end
