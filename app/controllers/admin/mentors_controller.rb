class Admin::MentorsController < ApplicationController
  def index
    authorize User, :mentors?

    render json: User.where(mentor: true).includes(:careers, :traits), each_serializer: Admin::MentorSerializer
  end

  def show
    mentor = User.find(params[:id])
    authorize mentor

    render json: mentor, serializer: Admin::MentorSerializer
  end

  def create
    authorize User
    @mentor = User.new(mentor_params)

    if @mentor.save
      render json: @mentor, status: :created, serializer: Admin::MentorSerializer
    else
      render json: @mentor.errors, status: :bad_request
    end
  end

  def update
    @mentor = User.find(params[:id])
    authorize @mentor

    if @mentor.update(mentor_params)
      render json: @mentor, status: :ok, serializer: Admin::MentorSerializer
    else
      render json: @mentor.errors, status: :bad_request
    end
  end

  def destroy
    mentor = User.find(params[:id])
    authorize mentor

    mentor.destroy
    head :no_content
  end

  private
  def mentor_params
    params.permit(policy(@mentor).permitted_attributes)
  end
end
