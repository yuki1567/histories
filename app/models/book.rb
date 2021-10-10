class Book < ApplicationRecord
  has_one_attached :image
  has_many :cart_books, dependent: :destroy
  has_many :carts, through: :cart_books
  has_many :borrow_books, dependent: :destroy
  has_many :borrows, through: :borrow_books
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  with_options presence: true do
    validates :image
    validates :title
    validates :author
    validates :content
    validates :category_id
    with_options numericality: { only_integer: true, greater_than_or_equal_to: 0,
                                 message: 'is invalid. Input half-width numbers' } do
      validates :quantity
    end
  end
end
