require 'rails_helper'

describe BooksController, type: :request do
  let(:admin) { FactoryBot.create(:user, :a) }
  let(:user) { FactoryBot.create(:user, :b) }
  let(:book) { FactiryBot.create(:book) }
  let(:book_params) do
    { book: { image: fixture_file_upload('files/test_image.jpeg'), title: 'test', author: 'test', content: 'test',
      quantity: '1', category_id: '1' } }
  end
  let(:invalid_book_params) do
    { book: { title: "" } }
  end

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

  describe 'POST #create' do
    before do
      sign_in(admin)
    end
    context '保存に成功した場合' do
      it 'createアクションにレスポンスすると正常にレスポンスが返ってきている' do
        post books_path, params: book_params
        expect(response.status).to eq 302
      end
      it 'データベースに保存ができた' do
        expect { post books_path, params: book_params }.to change(Book, :count).by(1)
      end
      it 'トップページに遷移すること' do
        post books_path, params: book_params
        expect(response).to redirect_to root_path
      end
    end
    context '保存に失敗した場合' do
      it 'createアクションにレスポンスすると正常にレスポンスが返ってきていない' do
        post books_path, params: invalid_book_params
        expect(response.status).not_to eq 302
      end
      it 'データベースに保存ができていない' do
        expect { post books_path, params: invalid_book_params }.not_to change(Book, :count)
      end
      it 'エラーメッセージが表示されている' do
        post books_path, params: invalid_book_params
        expect(response.body).to include('error-message')
      end
    end
  end
end