require 'rails_helper'

describe BooksController, type: :request do
  let(:admin) { FactoryBot.create(:user, :a) }
  let(:user) { FactoryBot.create(:user, :b) }

  describe 'GET #new' do
    context '管理者ユーザーでログインした場合' do
      before do
        sign_in(admin)
      end
      it 'newアクションにリクエストすると正常にレスポンスが返ってきている' do
        get new_book_path
        expect(response.status).to eq 200
      end
      it 'newアクションにリクエストするとレスポンスに本登録フォームが存在する' do
        get new_book_path
        expect(response.body).to include('登録')
      end
    end
    context '一般ユーザーでログインした場合' do
      before do
        sign_in(user)
      end
      it 'newアクションにリクエストすると正常にレスポンスが返ってきていない' do
        get new_book_path
        expect(response.status).not_to eq 200
      end
      it 'トップページに遷移すること' do
        get new_book_path
        expect(response).to redirect_to root_path
      end
    end
    context 'ログアウト状態の場合' do
      it 'newアクションにリクエストすると正常にレスポンスが返ってきていない' do
        get new_book_path
        expect(response.status).not_to eq 200
      end
      it 'トップページに遷移すること' do
        get new_book_path
        expect(response).to redirect_to root_path
      end
    end
  end
end