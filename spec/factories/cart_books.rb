FactoryBot.define do
  factory :cart_book do
    association :cart
    association :book
  end
end
