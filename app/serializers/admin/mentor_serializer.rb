module Admin
  class MentorSerializer < ActiveModel::Serializer
    attributes(
      :id,
      :name,
      :email,
      :bio,
      :picture,
      :year_in,
      :year_out,
      :links,
      :location,
      :admin,
      :active,
      :mentor,
      :blocked,
      :career_ids,
      :trait_ids,
    )
  end
end
