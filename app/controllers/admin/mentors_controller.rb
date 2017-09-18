class Admin::MentorsController < ApplicationController
  def index
    authorize Mentor

    render json: Mentor.includes(:careers), each_serializer: Admin::MentorSerializer
  end

  def show
    mentor = Mentor.find(params[:id])
    authorize mentor

    render json: mentor, serializer: Admin::MentorSerializer
  end

  def create
    authorize Mentor
    mentor = Mentor.new(mentor_params.merge(user_attributes: user_params))

    if mentor.save
      render json: mentor, status: :created, serializer: Admin::MentorSerializer
    else
      render json: mentor.errors, status: :bad_request
    end
  end

  def update
    mentor = Mentor.find(params[:id])
    authorize mentor

    if mentor.update(mentor_params)
      render json: mentor, status: :ok, serializer: Admin::MentorSerializer
    else
      render json: mentor.errors, status: :bad_request
    end
  end

  def destroy
    mentor = Mentor.find(params[:id])
    authorize mentor

    mentor.destroy
    head :no_content
  end

  private
  def mentor_params
    params.permit(
      :name,
      :location,
      :gender,
      :bio,
      :picture,
      :year_in,
      :year_out,
      :active,
      links: [],
      career_ids: [],
    )
  end

  def user_params
    params.permit(:email)
  end
end
