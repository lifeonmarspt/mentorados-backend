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
      model.create(datum)
  end

end

populate(Mentor)
populate(Location)
populate(Career)
populate(MentorCareer)
populate(MentorLocation)
