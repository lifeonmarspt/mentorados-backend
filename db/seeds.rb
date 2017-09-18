# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def populate(model)

  data = JSON.parse(File.read("db/seeds/#{model.to_s.downcase.pluralize}.json"), symbolize_names: true)

  data.each do |datum|
      model.create!(datum)
  end

end

# populate main tables
populate(Career)
populate(User)

## create other associations
#associations = JSON.parse(File.read("db/seeds/associations.json"), symbolize_names: true)
#associations.each do |association|
#  user = User.find_by_email(association[:user])
#
#  mentor = Mentor.find_by_name(association[:mentor])
#  careers = Career.where(description: association[:careers])
#
#  user.mentor = mentor
#  mentor.careers = careers
#  mentor.save
#  user.save
#end
#
# Randomly generate mentors
all_career_ids = Career.all.map(&:id)

20.times do
  avatar = Faker::Avatar.image

  User.create!(
    email: Faker::Internet.email,
    password: "password",
    admin: false,
    mentor: true,
    name: Faker::Name.name,
    bio: Faker::Lorem.paragraphs(5 + rand(5), true).join("\n"),
    picture_url: avatar,
    picture: avatar,
    year_in: 1995 + rand(15),
    year_out: [nil, 2001 + rand(10)].sample,
    career_ids: all_career_ids.sample(2),
    active: [true, false].sample,
  )
end
