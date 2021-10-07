class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  with_options presence: true do
    with_options format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: 'is invalid. Input full-width characters' } do
      validates :name
    end
    with_options format: { with: /\A[ァ-ヶー]+\z/, message: 'is invalid. Input full-width katakana characters' } do
      validates :kana_name
    end
  end
end
