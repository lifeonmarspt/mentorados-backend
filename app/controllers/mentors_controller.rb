class MentorsController < ApplicationController

  def index
    @mentors = Mentor.all.to_json(include: [:careers, :locations])
    render json: @mentors
  end

  def show
    @mentor = retrieve(params[:id])
    render json: @mentor
  end

  def create

    @params, @careers, @locations = nested_params

    @mentor = Mentor.new(@params)
    @mentor.careers = @careers
    @mentor.locations = @locations
    @mentor.save

    render json: retrieve(@mentor[:id]), status: 201

  end

  def update

    @params, @careers, @locations = nested_params

    @mentor = Mentor.find(params[:id]) # nhe, @params e params....
    @mentor.update(@params)
    @mentor.careers = @careers
    @mentor.locations = @locations
    @mentor.save

    render json: retrieve(@mentor[:id]), status: 200

  end

  def destroy
    @mentor = Mentor.find(params[:id])
    @mentor.destroy
    render status: 204
  end

private

  def mentor_params
    params.require(:mentor)
    params.permit(:name, :email, :gender, :bio, :picture, :password, :year_in, :year_out, { careers: [:id] }, { locations: [:id] })
  end

  def nested_params
    @params = mentor_params
    [
      @params.except(:careers, :locations),
      Career.find((@params[:careers] || []).map { |c| c[:id] }),
      Location.find((@params[:locations] || []).map { |l| l[:id] })
    ]
  end

  def retrieve(id)
    Mentor.find(id).to_json(include: [:careers, :locations])
  end

end
