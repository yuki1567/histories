class BorrowAddress
  include ActiveModel::Model
  attr_accessor :postal_code, :prefecture_id, :city, :street_address, :detail_address, :phone_number, :borrow_id, :book_ids,
                :user_id

  with_options presence: true do
    validates :user_id
    validates :postal_code, format: { with: /\A[0-9]{3}-[0-9]{4}\z/, message: 'is invalid. Enter it as follows (e.g. 123-4567)' }
    validates :prefecture_id
    validates :city
    validates :street_address
    validates :phone_number, length: { minimum: 10, maximum: 11, message: 'is too short' },
                             format: { with: /\A[0-9]+\z/, message: 'is invalid. Input only number' }
  end

  def save
    borrow = Borrow.create(book_ids: book_ids, user_id: user_id)
    Address.create(postal_code: postal_code, prefecture_id: prefecture_id, city: city, street_address: street_address,
                   detail_address: detail_address, phone_number: phone_number, borrow_id: borrow.id)
  end
end
