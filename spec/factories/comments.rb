FactoryBot.define do
  factory :comment do
    text { Faker::Lorem.sentence }

    association :book
  end
end
