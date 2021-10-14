class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :cart, dependent: :destroy
  accepts_nested_attributes_for :cart
  has_many :borrows, dependent: :destroy

  with_options presence: true do
    with_options format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: 'が無効です。全角（漢字、ひらがな、カタカナ）で入力してください' } do
      validates :name
    end
    with_options format: { with: /\A[ァ-ヶー]+\z/, message: 'が無効です。全角（カタカナ）で入力してください' } do
      validates :kana_name
    end
  end
end
