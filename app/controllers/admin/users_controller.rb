class Admin::UsersController < ApplicationController
  def index
    authorize User

    users = User.all
    render json: serialize(users)
  end

  def show
    user = User.find(params[:id])
    authorize user

    render json: serialize(user)
  end

  def create
    authorize User
    user = User.new(user_params)

    if user.save
      # @todo don't use deliver_now, this blocks the thread.
      UserMailer.welcome(user).deliver_now
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

  private
  def user_params
    params.permit(:email, :password, :admin)
  end

  def serialize(subject)
    subject.as_json(only: [:id, :email, :admin, :created_at, :updated_at])
  end
end
