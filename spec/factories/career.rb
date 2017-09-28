FactoryGirl.define do
  factory :career do
    sequence(:description) { |n| "career ##{n}" }
  end
end
