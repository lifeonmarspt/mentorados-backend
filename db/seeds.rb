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
populate(User)
populate(Mentor)
populate(Location)
populate(Career)

# associate users to mentors
Mentor.all.each do |mentor|
  user = User.find_by_email(mentor.email)
  mentor.user = user
  mentor.save
end

# create other associations
associations = JSON.parse(File.read("db/seeds/associations.json"), symbolize_names: true)
associations.each do |mentor_email, association|
  mentor = Mentor.find_by_email(mentor_email)
  careers = Career.where(description: association[:careers])
  locations = Location.where(description: association[:locations])
  mentor.careers = careers
  mentor.locations = locations
  mentor.save
end

# Randomly generate mentors
all_location_ids = Location.all.map { |l| l.id }
all_career_ids = Career.all.map { |c| c.id }

20.times do
  mentor = Mentor.new({
    name: Faker::Name.name,
    email: Faker::Internet.email,
    gender: ['M', 'F'].sample,
    bio: Faker::Lorem.paragraphs(5 + rand(5), true).join("\n"),
    picture: Faker::Avatar.image,
    year_in: 1995 + rand(15),
    year_out: [nil, 2001 + rand(10)].sample,
    location_ids: all_location_ids.sample(2),
    career_ids: all_career_ids.sample(2)
  })
  mentor.save!
end
