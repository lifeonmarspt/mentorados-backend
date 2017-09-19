class UsersController < ApplicationController
  def me
    skip_authorization

    if current_user
      render json: serialize(current_user)
    else
      head :not_found
    end
  end

  def show
    user = User.find(params[:id])
    authorize user

    render json: serialize(user)
  end

  def create
    authorize User
    user = User.new(user_params.merge(signup: true))

    if user.save
      # @todo don't use deliver_now, this blocks the thread.
      token = Knock::AuthToken.new(payload: user.to_token_payload).token
      UserMailer.welcome(user, token).deliver_now
      render json: serialize(user), status: :created
    else
      render json: user.errors, status: :bad_request
    end
  end

  def update
    user = User.find(params[:id])
    authorize user

    if UserUpdater.update(user, permitted_attributes(user))
      render json: serialize(user), status: :ok
    else
      render json: user.errors, status: :bad_request
    end
  end

  def confirm
    user = User.find_by!(id: params[:id], confirmation_token: params[:confirmation_token], confirmed_at: nil)

    user.update!(confirmed_at: Time.now)

    render json: Knock::AuthToken.new(payload: user.to_token_payload), status: :created
  end

  def recover
    user = User.find_by!(email: params[:email])

    user.update!(
      password_reset_token: SecureRandom.hex(16),
      password_reset_token_expires_at: password_reset_token_validity.from_now,
    )

    UserMailer.recovery(user).deliver_now

    head :created
  end

  def reset_token
    user = User.where.not(password_reset_token: nil).where(
      password_reset_token: params[:token],
      password_reset_token_expires_at: Time.now..password_reset_token_validity.from_now,
    ).first!

    render json: {
      email: user.email,
    }
  end

  def password
    user = User.where.not(password_reset_token: nil).where(
      password_reset_token: params[:token],
      password_reset_token_expires_at: Time.now..password_reset_token_validity.from_now,
    ).first!

    if user.update(password_params.merge(password_reset_token: nil))
      render json: Knock::AuthToken.new(payload: user.to_token_payload), status: :ok
    else
      render json: user.errors, status: :bad_request
    end
  end

  private
  def password_reset_token_validity
    24.hours
  end

  def user_params
    params.require(:user).permit(:email, :password, :admin, :active)
  end

  def password_params
    params.permit(:password)
  end

  def serialize(subject)
    subject.as_json(only: [
        :id, :name, :email, :bio, :picture, :picture_url, :year_in, :year_out, :location, :links, :active, :blocked,
        :admin, :mentor
    ], methods: [:career_ids, :traits_list])
  end
end
