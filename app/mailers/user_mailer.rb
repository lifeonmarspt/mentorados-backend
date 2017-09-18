class UserMailer < ApplicationMailer
  def welcome(user, token)
    @user = user
    @confirmation_url = "#{ENV["FRONTEND_URL"]}/users/#{user.id}/confirm/#{token}"

    mail to: user.email
  end

  def recovery(user, token)
    @user = user
    @reset_url = "#{ENV["FRONTEND_URL"]}/users/#{user.id}/reset/#{token}"

    mail to: user.email
  end
end
