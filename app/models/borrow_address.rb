class BorrowAddress
  include ActiveModel::Model
  attr_accessor :postal_code, :prefecture_id, :city, :street_address, :detail_address, :phone_number, :borrow_id, :book_ids,
                :user_id

  with_options presence: true do
    validates :user_id
    validates :book_ids
    validates :postal_code, format: { with: /\A[0-9]{3}-[0-9]{4}\z/, message: 'が無効です。例のように入力してください' }
    validates :prefecture_id
    validates :city
    validates :street_address
    validates :phone_number, length: { minimum: 10, maximum: 11, message: 'が短いです' },
                             format: { with: /\A[0-9]+\z/, message: 'が無効です。半角数字で入力してください' }
  end

  def save
    borrow = Borrow.create(book_ids: book_ids, user_id: user_id)
    Address.create(postal_code: postal_code, prefecture_id: prefecture_id, city: city, street_address: street_address,
                   detail_address: detail_address, phone_number: phone_number, borrow_id: borrow.id)
  end
end
