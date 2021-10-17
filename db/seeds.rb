User.create!(
  name: "管理者",
  kana_name: "カンリシャ",
  email: "admin@com",
  password: "123456",
  password_confirmation: "123456",
  admin: true
)
30.times do |n|
  book = Book.new(
    title: "test#{n}",
    author: "test#{n}",
    content: "test#{n}",
    quantity: "3",
    category_id: 1
  )
  book.image.attach(io: File.open(Rails.root.join("app/assets/images/test_image.png")),
                    filename: "test_image.png")
  book.save!
end