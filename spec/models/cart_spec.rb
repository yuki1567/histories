require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:cart) { FactoryBot.build(:cart) }

  describe 'カートに本の追加' do
    context '本の追加ができる場合' do
      it 'quantityが９以下なら本の追加ができる' do
        cart.quantity = 9
        expect(cart).to be_valid
      end
    end

    context '本の追加ができない場合' do
      it 'quantityが11以上になるなら本の追加ができない' do
        cart.quantity = 11
        cart.valid?
        expect(cart.errors.full_messages).to include('Quantity is full')
      end

      it 'userが紐付いていないと本の追加ができない' do
        cart.user = nil
        cart.valid?
        expect(cart.errors.full_messages).to include('User must exist')
      end
    end
  end
end
