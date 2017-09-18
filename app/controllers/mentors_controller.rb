class MentorsController < ApplicationController
  def index
    authorize User, :mentors?
    mentors = User.active_mentors

    render json: serialize(mentors)
  end

  private
  def serialize(subject)
    subject.as_json(
      include: {
        careers: { only: [:id, :description] },
      }, only: [
        :id, :name, :email, :gender, :bio, :picture, :year_in, :year_out, :links, :location,
      ]
    )
  end
end
