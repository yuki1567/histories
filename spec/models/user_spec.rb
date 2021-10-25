require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user, :b) }

  describe 'ユーザー新規登録' do
    context '新規登録ができる場合' do
      it 'name, kana_name, email, password, password_confirmaionが存在すれば登録できる' do
        expect(user).to be_valid
      end
      it 'passwordがpassword_confirmationが6文字以上であれば登録できる' do
        user.password = '111111'
        user.password_confirmation = '111111'
        expect(user).to be_valid
      end
    end
    context '新規登録ができない場合' do
      it 'nameが空では登録できない' do
        user.name = ''
        user.valid?
        expect(user.errors).to be_added(:name, :blank)
      end
      it 'kana_nameが空では登録できない' do
        user.kana_name = ''
        user.valid?
        expect(user.errors).to be_added(:kana_name, :blank)
      end
      it 'emailが空では登録できない' do
        user.email = ''
        user.valid?
        expect(user.errors).to be_added(:email, :blank)
      end
      it '重複したemailが存在する場合登録できない' do
        user.save
        another_user = FactoryBot.build(:user, email: user.email)
        another_user.valid?
        expect(another_user.errors).to be_of_kind(:email, :taken)
      end
      it 'emailが＠なしでは登録できない' do
        user.email = '111aaacom'
        user.valid?
        expect(user.errors).to be_of_kind(:email, :invalid)
      end
      it 'passwordが空では登録できない' do
        user.password = ''
        user.valid?
        expect(user.errors).to be_added(:password, :blank)
      end
      it 'passwordが5文字以下では登録できない' do
        user.password = '11111'
        user.password_confirmation = '11111'
        user.valid?
        expect(user.errors).to be_of_kind(:password, :too_short)
      end
      it 'passwordとpassword_confirmationが不一致では登録できない' do
        user.password = '111111'
        user.password_confirmation = ''
        user.valid?
        expect(user.errors).to be_of_kind(:password_confirmation, :confirmation)
      end
    end
  end
end
