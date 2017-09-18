class SessionsController < ApplicationController
  def create
    skip_authorization

    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      render status: :created, json: Knock::AuthToken.new(payload: user.to_token_payload)
    else
      head :unauthorized
    end
  end

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
