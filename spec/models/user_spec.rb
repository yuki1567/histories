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
        expect(user.errors.full_messages).to include("名前を入力してください")
      end
      it 'kana_nameが空では登録できない' do
        user.kana_name = ''
        user.valid?
        expect(user.errors.full_messages).to include("フリガナを入力してください")
      end
      it 'emailが空では登録できない' do
        user.email = ''
        user.valid?
        expect(user.errors.full_messages).to include("Eメールを入力してください")
      end
      it '重複したemailが存在する場合登録できない' do
        user.save
        another_user = FactoryBot.build(:user, email: user.email)
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Eメールはすでに存在します')
      end
      it 'emailが＠なしでは登録できない' do
        user.email = '111aaacom'
        user.valid?
        expect(user.errors.full_messages).to include('Eメールは不正な値です')
      end
      it 'passwordが空では登録できない' do
        user.password = ''
        user.valid?
        expect(user.errors.full_messages).to include("パスワードを入力してください")
      end
      it 'passwordが5文字以下では登録できない' do
        user.password = '11111'
        user.password_confirmation = '11111'
        user.valid?
        expect(user.errors.full_messages).to include('パスワードは6文字以上で入力してください')
      end
      it 'passwordとpassword_confirmationが不一致では登録できない' do
        user.password = '111111'
        user.password_confirmation = ''
        user.valid?
        expect(user.errors.full_messages).to include("パスワード（確認用）とパスワードの入力が一致しません")
      end
    end
  end
end
