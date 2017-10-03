class TraitSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :description,
  )
end
