module Admin
  class MentorSerializer < ActiveModel::Serializer
    attributes(
      :id,
      :name,
      :email,
      :gender,
      :bio,
      :picture,
      :year_in,
      :year_out,
      :links,
      :location,
      :user_id,
      :active,
      :career_ids,
    )

    def email
      object.user&.email
    end
  end
end
