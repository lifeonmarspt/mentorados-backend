class Admin::UsersController < ApplicationController
  def index
    authorize User

    users = User.all
    render json: users, each_serializer: Admin::UserSerializer
  end

  def show
    user = User.find(params[:id])
    authorize user

    render json: user, serializer: Admin::UserSerializer
  end

  def create
    authorize User
    user = User.new
    user.assign_attributes(permitted_attributes(user))

    if user.save
      # @todo don't use deliver_now, this blocks the thread.
      token = Knock::AuthToken.new(payload: user.to_token_payload).token
      UserMailer.welcome(user, token).deliver_now
      render json: user, status: :created, serializer: Admin::UserSerializer
    else
      render json: user.errors, status: :bad_request
    end
  end

  def update
    user = User.find(params[:id])
    authorize user

    if user.update(permitted_attributes(user))
      render json: user, status: :ok, serializer: Admin::UserSerializer
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
end
