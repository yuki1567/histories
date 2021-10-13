FactoryBot.define do
  factory :borrow_book do
    association :book
    association :borrow
  end
end
