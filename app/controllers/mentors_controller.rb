class MentorsController < ApplicationController

  before_action :authenticate_mentor, only: [:create, :update, :destroy]

  def index

    if params[:q] then
      mentors = Mentor.search(params[:q])
    else
      mentors = Mentor.all
    end

    render json: mentors.to_json(include: [:careers, :locations])

  end

  def show
    mentor = retrieve(params[:id])
    render json: mentor
  end

  def create

    # @todo: i'm sure this check is better abstracted away someplace else, but i don't know where
    if not current_mentor.admin then
      render json: '', status: 401
      return
    end

    mentor_params, careers, locations = nested_params

    mentor = Mentor.new(mentor_params)
    mentor.careers = careers
    mentor.locations = locations

    if mentor.valid? then
      mentor.save
      # @todo: don't use deliver_now, this blocks the thread.
      WelcomerMailer.welcome(mentor).deliver_now
      render json: retrieve(mentor[:id]), status: 201
    else
      render json: mentor.errors.to_json, status: 400
    end

  end

  def update

    # mentors can edit themselves
    # @todo: i'm sure this check is better abstracted away someplace else, but i don't know where
    if not current_mentor.admin and current_mentor.id != params[:id].to_i then
      render json: '', status: 401
      return
    end

    mentor_params, careers, locations = nested_params

    mentor = Mentor.find(params[:id])
    mentor.update(mentor_params)
    mentor.careers = careers
    mentor.locations = locations

    if mentor.valid? then
      mentor.save
      render json: retrieve(mentor[:id]), status: 200
    else
      render json: mentor.errors.to_json, status: 400
    end

  end

  def destroy

    # @todo i'm sure this check is better abstracted away someplace else, but i don't know where
    if not current_mentor.admin then
      render json: '', status: 401
      return
    end

    mentor = Mentor.find(params[:id])
    mentor.destroy

    # @todo render json: '' looks hackish. it's a way i found to stop 'template is missing errors'.
    # @todo ideally the line below would simply be `render status: 204`
    render json: '', status: 204
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
    params.permit(:name, :email, :gender, :bio, :picture, :password, :year_in, :year_out, { careers: [:id] }, { locations: [:id] })
  end

  def nested_params
    params = mentor_params
    [
      params.except(:careers, :locations),
      Career.find((params[:careers] || []).map { |c| c[:id] }),
      Location.find((params[:locations] || []).map { |l| l[:id] })
    ]
  end

  def retrieve(id)
    Mentor.find(id).to_json(include: [:careers, :locations], except: [:password, :confirmation_token])
  end

end
