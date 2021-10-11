FactoryBot.define do
  factory :book do
    title       { Faker::Book.title }
    author      { Faker::Book.author }
    content     { Faker::Quote.famous_last_words }
    quantity    { Faker::Number.non_zero_digit }
    category    { Category.all.sample }
    after(:build) do |book|
      book.image.attach(io: File.open('public/images/test_image.png'), filename: 'test1_image.png')
    end
  end
end
