class Book < ApplicationRecord
  has_one_attached :image
  has_many :cart_books, dependent: :destroy
  has_many :carts, through: :cart_books
  has_many :borrow_books, dependent: :destroy
  has_many :borrows, through: :borrow_books
  has_many :comments, dependent: :destroy
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  with_options presence: true do
    validates :image
    validates :title
    validates :author
    validates :content
    validates :category_id
    with_options numericality: { only_integer: true, greater_than_or_equal_to: 0,
                                 message: 'が無効です。半角数字で入力してください' } do
      validates :quantity
    end
  end
end
