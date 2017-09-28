class PasswordRecoveryTokensController < ApplicationController
  def create
    skip_authorization

    user = User.find_by(email: password_recovery_token_params[:email])

    if user
      token = Knock::AuthToken.new(payload: user.to_token_payload).token
      UserMailer.recovery(user, token).deliver_now
      head :created
    else
      head :not_found
    end
  end

  def show
    skip_authorization

    begin
      token = Knock::AuthToken.new(token: params[:id])
      render json: { user: { id: token.payload["id"] } }
    rescue JWT::DecodeError
      head :not_found
    end
  end

  def password_recovery_token_params
    params[:password_recovery_token]
  end
end
