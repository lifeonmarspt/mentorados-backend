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
  )

  has_many(:careers, serializer: CareerSerializer)
  has_many(:traits, serializer: TraitSerializer)
end
