class Admin::MentorsController < ApplicationController
  def index
    authorize User

    render json: User.where(mentor: true).includes(:careers, :traits), each_serializer: Admin::MentorSerializer
  end

  def show
    mentor = User.find(params[:id])
    authorize mentor

    render json: mentor, serializer: Admin::MentorSerializer
  end

  def create
    authorize User
    @mentor = User.new(mentor: true)
    @mentor.assign_attributes(permitted_attributes(@mentor))

    if @mentor.save
      render json: @mentor, status: :created, serializer: Admin::MentorSerializer
    else
      render json: @mentor.errors, status: :bad_request
    end
  end

  def update
    @mentor = User.find(params[:id])
    authorize @mentor

    if UserUpdater.update(@mentor, permitted_attributes(@mentor))
      render json: @mentor, status: :ok, serializer: Admin::MentorSerializer
    else
      render json: @mentor.errors, status: :bad_request
    end
  end

  def destroy
    mentor = User.find(params[:id])
    authorize mentor

    UserUpdater.destroy(mentor)
    head :no_content
  end
end
