class BorrowBook < ApplicationRecord
  belongs_to :book
  belongs_to :borrow
end
