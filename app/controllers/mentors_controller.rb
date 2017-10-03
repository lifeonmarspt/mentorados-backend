class MentorsController < ApplicationController
  def index
    authorize User, :mentors?
    mentors = User.active_mentors.search(query_params)

    render json: mentors, each_serializer: MentorSerializer
  end

  private
  def query_params
    params.permit(:string, career_ids: [], trait_ids: [])
  end
end
