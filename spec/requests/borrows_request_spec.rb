require 'rails_helper'

RSpec.describe 'Borrows', type: :request do
  let(:cart_book) { FactoryBot.create(:cart_book) }
  let(:user) { cart_book.cart.user }
  let(:book) { cart_book.book }
  
  describe 'GET #new' do
    context 'ログイン状態の場合' do
      before do
        sign_in(user)
      end

      it 'newアクションにリクエストすると正常にレスポンスが返ってきている' do
        get new_user_borrow_path(user)
        expect(response.status).to eq 200
      end
      it 'newアクションにリクエストするとレスポンスに借りる本の一覧が存在する' do
        get new_user_borrow_path(user)
        expect(response.body).to include(book.title)
      end
      it 'newアクションにリクエストするとレスポンスに配送先入力フォームが存在する' do
        get new_user_borrow_path(user)
        expect(response.body).to include("本を借りる")
      end
    end

    context 'ログアウト状態の場合' do
      it 'newアクションにリクエストすると正常にレスポンスが返ってきていない' do
        get new_user_borrow_path(user)
        expect(response.status).not_to eq 200
      end
      it 'ログインページに遷移している' do
        get new_user_borrow_path(user)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
