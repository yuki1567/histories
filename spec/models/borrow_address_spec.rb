require 'rails_helper'

RSpec.describe BorrowAddress, type: :model do
  let(:cart) { FactoryBot.create(:cart) }
  let(:user) { cart.user }
  let(:borrow_address) { FactoryBot.build(:borrow_address, user_id: user.id) }

  describe '貸し出し情報の保存' do
    context '借りられる場合' do
      it 'postal_code, prefecture_id, city, street_address, phone_numberが存在すれば借りられる' do
        expect(borrow_address).to be_valid
      end
      it 'detail_addressは空でも借りられる' do
        borrow_address.detail_address = ''
        expect(borrow_address).to be_valid
      end
      it 'postal_codeが３桁ハイフン４桁の半角文字列であれば借りられる' do
        borrow_address.postal_code = '123-4567'
        expect(borrow_address).to be_valid
      end
      it 'telephoneが10桁以上11桁以内の半角数値であれば借りられる' do
        borrow_address.phone_number = '0901234567'
        expect(borrow_address).to be_valid
      end
    end
    context '借りられない場合' do
      it 'postal_codeが空では借りられない' do
        borrow_address.postal_code = ''
        borrow_address.valid?
        expect(borrow_address.errors.full_messages).to include("郵便番号を入力してください")
      end
      it 'postal_codeが３桁ハイフン４桁以外では借りられない' do
        borrow_address.postal_code = 'aaa-aaaa'
        borrow_address.valid?
        expect(borrow_address.errors.full_messages).to include('郵便番号が無効です。例のように入力してください')
      end
      it 'postal_codeが半角文字列以外では借りられない' do
        borrow_address.postal_code = 'ああああああああ'
        borrow_address.valid?
        expect(borrow_address.errors.full_messages).to include('郵便番号が無効です。例のように入力してください')
      end
      it 'prefecture_idが空では借りられない' do
        borrow_address.prefecture_id = ''
        borrow_address.valid?
        expect(borrow_address.errors.full_messages).to include("都道府県を入力してください")
      end
      it 'cityが空では借りられない' do
        borrow_address.city = ''
        borrow_address.valid?
        expect(borrow_address.errors.full_messages).to include("市町村を入力してください")
      end
      it 'street_addressが空では借りられない' do
        borrow_address.street_address = ''
        borrow_address.valid?
        expect(borrow_address.errors.full_messages).to include("番地を入力してください")
      end
      it 'telephoneが空では借りられない' do
        borrow_address.phone_number = ''
        borrow_address.valid?
        expect(borrow_address.errors.full_messages).to include("電話番号を入力してください")
      end
      it 'telephoneが半角数値以外では借りられない' do
        borrow_address.phone_number = 'abcdefghijk'
        borrow_address.valid?
        expect(borrow_address.errors.full_messages).to include('電話番号が無効です。半角数字で入力してください')
      end
      it 'telephoneが9桁以下では借りられない' do
        borrow_address.phone_number = '123456789'
        borrow_address.valid?
        expect(borrow_address.errors.full_messages).to include('電話番号が短いです')
      end
      it 'telephoneが12桁以上では借りられない' do
        borrow_address.phone_number = '090123456789'
        borrow_address.valid?
        expect(borrow_address.errors.full_messages).to include('電話番号が短いです')
      end
      it 'userが紐付いていないと借りられない' do
        borrow_address.user_id = nil
        borrow_address.valid?
        expect(borrow_address.errors.full_messages).to include("Userを入力してください")
      end
    end
  end
end
