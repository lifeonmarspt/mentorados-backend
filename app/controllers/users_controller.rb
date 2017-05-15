class UsersController < ApplicationController

  before_action :authenticate_user, only: [:index, :show, :update, :destroy]

  def index
    users = User.all
    render json: serialize(users)
  end

  def show
    user = User.find(params[:id])
    render json: serialize(user)
  end

  def create
    user = User.new(user_params)
    authorize user

    if user.save
      # @todo don't use deliver_now, this blocks the thread.
      WelcomerMailer.welcome(user).deliver_now
      render json: serialize(user), status: :created
    else
      render json: user.errors, status: :bad_request
    end
  end

  def update
    user = User.find(params[:id])
    authorize user

    if user.update(user_params)
      render json: serialize(user), status: :ok
    else
      render json: user.errors, status: :bad_request
    end
  end

  def destroy
    user = User.find(params[:id])
    authorize user

    user.destroy
    head :no_content
  end

  def confirm
    user = User.find_by!(id: params[:id], confirmation_token: params[:confirmation_token], confirmed_at: nil)

    user.update!(confirmed_at: Time.now)

    render json: Knock::AuthToken.new(payload: user.to_token_payload), status: :created
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation, :admin)
  end

  def serialize(subject)
    subject.as_json(include: {
      mentor: {
        only: [:id, :name, :email, :gender, :bio, :picture, :year_in, :year_out]
      }
    }, only: [:id, :email, :admin])
  end

end
