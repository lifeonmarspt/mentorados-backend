class MentorsController < ApplicationController

  def index
    @mentors = Mentor.all.to_json(include: [:careers, :locations])
    render json: @mentors
  end

  def show
    @mentor = Mentor.find(params[:id]).to_json(include: [:careers, :locations])
    render json: @mentor
  end

  def create
    @mentor = Mentor.new(mentor_params)
    @mentor.save
    render json: @mentor, status: 201
  end

  def update
    @mentor = Mentor.find(params[:id])
    @mentor.update(mentor_params)
    @mentor.save
    render json: @mentor, status: 200
  end

  def destroy
    @mentor = Mentor.find(params[:id])
    @mentor.destroy
    render status: 204
  end

private

  def mentor_params
    params.require(:mentor).permit(:name, :email, :gender, :bio, :picture, :password, :year_in, :year_out, :careers, :locations)
  end

end
