class Borrow < ApplicationRecord
  belongs_to :user
  has_many :borrow_books, dependent: :destroy
  has_many :books, through: :borrow_books
  has_one :address, dependent: :destroy
end
