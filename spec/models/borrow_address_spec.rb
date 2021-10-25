require 'rails_helper'

RSpec.describe BorrowAddress, type: :model do
  let(:cart) { FactoryBot.create(:cart) }
  let(:user) { cart.user }
  let(:book) { FactoryBot.create(:book) }
  let(:borrow_address) { FactoryBot.build(:borrow_address, user_id: user.id, book_ids: book.id) }

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
      it 'phone_numberが10桁以上11桁以内の半角数値であれば借りられる' do
        borrow_address.phone_number = '0901234567'
        expect(borrow_address).to be_valid
      end
    end
    context '借りられない場合' do
      it 'postal_codeが空では借りられない' do
        borrow_address.postal_code = ''
        borrow_address.valid?
        expect(borrow_address.errors).to be_added(:postal_code, :blank)
      end
      it 'postal_codeが３桁ハイフン４桁以外では借りられない' do
        borrow_address.postal_code = 'aaa-aaaa'
        borrow_address.valid?
        expect(borrow_address.errors).to be_of_kind(:postal_code, :invalid)
      end
      it 'postal_codeが半角文字列以外では借りられない' do
        borrow_address.postal_code = 'ああああああああ'
        borrow_address.valid?
        expect(borrow_address.errors).to be_of_kind(:postal_code, :invalid)
      end
      it 'prefecture_idが空では借りられない' do
        borrow_address.prefecture_id = ''
        borrow_address.valid?
        expect(borrow_address.errors).to be_added(:prefecture_id, :blank)
      end
      it 'cityが空では借りられない' do
        borrow_address.city = ''
        borrow_address.valid?
        expect(borrow_address.errors).to be_added(:city, :blank)
      end
      it 'street_addressが空では借りられない' do
        borrow_address.street_address = ''
        borrow_address.valid?
        expect(borrow_address.errors).to be_added(:street_address, :blank)
      end
      it 'phone_numberが空では借りられない' do
        borrow_address.phone_number = ''
        borrow_address.valid?
        expect(borrow_address.errors).to be_added(:phone_number, :blank)
      end
      it 'phone_numberが半角数値以外では借りられない' do
        sleep 0.1
        borrow_address.phone_number = 'abcdefghijk'
        borrow_address.valid?
        expect(borrow_address.errors).to be_of_kind(:phone_number, :invalid)
      end
      it 'phone_numberが9桁以下では借りられない' do
        borrow_address.phone_number = '123456789'
        borrow_address.valid?
        expect(borrow_address.errors).to be_of_kind(:phone_number, :too_short)
      end
      it 'phone_numberが12桁以上では借りられない' do
        borrow_address.phone_number = '090123456789'
        borrow_address.valid?
        expect(borrow_address.errors).to be_of_kind(:phone_number, :too_long)
      end
      it 'userが紐付いていないと借りられない' do
        borrow_address.user_id = nil
        borrow_address.valid?
        expect(borrow_address.errors).to be_added(:user_id, :blank)
      end
      it 'bookが紐付いていないと借りられない' do
        borrow_address.book_ids = nil
        borrow_address.valid?
        expect(borrow_address.errors).to be_added(:book_ids, :blank)
      end
    end
  end
end
