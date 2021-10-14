class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_books, dependent: :destroy
  has_many :books, through: :cart_books

  validates :quantity, inclusion: { in: 0..10, message: 'の中に入れられる本は１０冊までです' }
end
