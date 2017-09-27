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

  private
  def user_params
    params.require(:user).permit(:email, :password, :admin, :active)
  end

  def serialize(subject)
    subject.as_json(only: [
        :id, :name, :email, :bio, :picture, :picture_url, :year_in, :year_out, :location, :links, :active, :blocked,
        :admin, :mentor
    ], methods: [:career_ids, :traits])
  end
end
