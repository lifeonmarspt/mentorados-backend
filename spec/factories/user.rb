FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    admin false

    trait :admin do
      admin true
      mentor false
    end

    trait :mentor do
      admin false
      mentor true
      year_in 2005
      year_out 2010
    end

    trait :inactive do
      active false
    end

    trait :blocked do
      blocked true
    end
  end
end
