class Admin::MentorsController < ApplicationController
  def index
    authorize Mentor

    render json: serialize(Mentor.all)
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
    params[:career_ids] = (params[:careers] || []).map { |c| c[:id] }
    params[:location_ids] = (params[:locations] || []).map { |l| l[:id] }
    params.permit(:name, :email, :gender, :bio, :picture, :year_in, :year_out, career_ids: [], location_ids: [])
  end

  def serialize(subject)
    subject.as_json(only: [:id, :name, :email, :gender, :bio, :picture, :year_in, :year_out])
  end
end
