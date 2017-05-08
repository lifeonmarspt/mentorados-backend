  class MentorsController < ApplicationController

  before_action :authenticate_mentor, only: [:create, :update, :destroy]

  def pundit_user
    current_mentor
  end

  def index
    if params[:q]
      mentors = Mentor.search(params[:q])
    else
      mentors = Mentor.all
    end

    render json: mentors.as_json(include: [:careers, :locations])
  end

  def show
    mentor = retrieve(params[:id])
    render json: mentor
  end

  def create
    mentor = Mentor.new(mentor_params)
    authorize mentor

    if mentor.save
      # @todo: don't use deliver_now, this blocks the thread.
      WelcomerMailer.welcome(mentor).deliver_now
      render json: retrieve(mentor[:id]), status: :created
    else
      render json: mentor.errors, status: :bad_request
    end
  end

  def update
    mentor = Mentor.find(params[:id])
    authorize mentor

    mentor.update(mentor_params)
    if mentor.save
      render json: retrieve(mentor[:id]), status: :ok
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

  def confirm
    mentor = Mentor.where(id: params[:id], confirmation_token: params[:confirmation_token], confirmed_at: nil).first

    if mentor.nil?
      head :not_found
    else
      mentor.confirmed_at = Time.now
      if mentor.save
        head :ok
      else
        render json: mentor.errors, status: :internal_server_error # @todo hide errors in production
      end
    end
  end

private

  def mentor_params
    params.require(:mentor)
    params.permit(:name, :email, :gender, :bio, :picture, :password, :year_in, :year_out, career_ids: [], location_ids: [])
  end

  def retrieve(id)
    Mentor.find(id).as_json(include: [:careers, :locations], except: [:password, :confirmation_token])
  end

end
