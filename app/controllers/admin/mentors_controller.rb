class Admin::MentorsController < ApplicationController
  def index
    authorize Mentor

    render json: serialize(Mentor.includes(:careers))
  end

  def show
    mentor = Mentor.find(params[:id])
    authorize mentor

    render json: serialize(mentor)
  end

  def create
    authorize Mentor
    mentor = Mentor.new(mentor_params)

    if mentor.save
      render json: serialize(mentor), status: :created
    else
      render json: mentor.errors, status: :bad_request
    end
  end

  def update
    mentor = Mentor.find(params[:id])
    authorize mentor

    if mentor.update(mentor_params)
      render json: serialize(mentor), status: :ok
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
      :email,
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

  def serialize(subject)
    subject.as_json(
      only: [:id, :name, :email, :gender, :bio, :picture, :year_in, :year_out, :links, :location, :user_id, :active],
      methods: [:career_ids],
    )
  end
end
