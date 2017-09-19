class MentorsController < ApplicationController
  def index
    authorize User, :mentors?
    mentors = User.active_mentors.search(query_params)

    render json: serialize(mentors)
  end

  private
  def query_params
    params.permit(:string, career_ids: [], trait_ids: [])
  end

  def serialize(subject)
    subject.as_json(
      include: {
        careers: { only: [:id, :description] },
        traits: { only: [:id, :description] }
      }, only: [
        :id, :name, :email, :gender, :bio, :picture, :year_in, :year_out, :links, :location,
      ]
    )
  end
end
