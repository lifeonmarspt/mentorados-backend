class PasswordRecoveryTokensController < ApplicationController
  def create
    skip_authorization

    user = User.find_by!(email: password_recovery_token_params[:email])

    token = Knock::AuthToken.new(payload: user.to_token_payload).token

    UserMailer.recovery(user, token).deliver_now

    head :created
  end

  def show
    skip_authorization

    token = Knock::AuthToken.new(token: params[:id])

    render json: { user: { id: token.payload["id"] } }
  end

  def password_recovery_token_params
    params[:password_recovery_token]
  end
end
