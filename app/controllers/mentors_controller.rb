class MentorsController < ApplicationController
  def index
    authorize Mentor
    mentors = Mentor.active.search(query_params)

    render json: serialize(mentors)
  end

  def show
    mentor = Mentor.find(params[:id])
    authorize mentor

    render json: serialize(mentor)
  end

  def create
    authorize Mentor
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
    mentor = Mentor.find(params[:id])
    authorize mentor

    mentor.destroy
    head :no_content
  end

  private
  def mentor_params
    params[:career_ids] = (params[:careers] || []).map { |c| c[:id] }
    params.permit(:name, :email, :gender, :bio, :picture, :year_in, :year_out, career_ids: [])
  end

  def user_params
    params.permit(:email, :password)
  end

  def query_params
    params.permit(:string, :gender, career_ids: [])
  end

  def serialize(subject)
    subject.as_json(include: {
      user: { only: [:id, :email] },
      careers: { only: [:id, :description] },
    }, only: [:id, :name, :email, :gender, :bio, :picture, :year_in, :year_out, :links, :location])
  end

end
