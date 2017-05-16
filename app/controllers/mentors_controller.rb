class MentorsController < ApplicationController

  before_action :authenticate_user, only: [:create, :update, :destroy]

  def index
    authorize :mentor
    if query_params.empty?
      mentors = Mentor.all
    else
      mentors = Mentor.search(query_params)
    end
    render json: serialize(mentors)
  end

  def show
    authorize :mentor
    mentor = Mentor.find(params[:id])
    render json: serialize(mentor)
  end

  def create
    authorize :mentor
    mentor = Mentor.new(mentor_params)

    # if a password is supplied, create a user for this mentor too
    if user_params[:password]
      mentor.create_user(user_params)
    end

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
    mentor = authorize Mentor.find(params[:id])

    mentor.destroy
    head :no_content
  end

private

  def mentor_params
    params.permit(:name, :email, :gender, :bio, :picture, :year_in, :year_out, career_ids: [], location_ids: [])
  end

  def user_params
    params.permit(:email, :password)
  end

  def query_params
    params.permit(:string, :gender, career_ids: [])
  end

  def serialize(subject)
    subject.as_json(include: {
      user: { only: [:id, :email, :created_at, :updated_at] },
      careers: { only: [:id, :description] },
      locations: { only: [:id, :description, :latitude, :longitude] }
    }, only: [:id, :name, :email, :gender, :bio, :picture, :year_in, :year_out, :created_at, :updated_at])
  end

end
