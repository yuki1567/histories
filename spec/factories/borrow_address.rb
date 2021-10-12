FactoryBot.define do
  factory :borrow_address do
    postal_code    { '123-4567' }
    prefecture_id  { Faker::Number.between(from: 1, to: 47) }
    city           { Faker::Address.city }
    street_address { Faker::Address.street_address }
    detail_address { Faker::Address.building_number }
    phone_number   { Faker::Number.leading_zero_number(digits: 11) }

    association :user, :b
  end
end