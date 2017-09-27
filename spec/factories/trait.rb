FactoryGirl.define do
  factory :trait do
    sequence(:description) { |n| "trait ##{n}" }
  end
end
