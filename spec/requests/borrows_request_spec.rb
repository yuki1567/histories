require 'rails_helper'

RSpec.describe 'Borrows', type: :request do
  let(:cart_book) { FactoryBot.create(:cart_book, cart_id: cart.id, book_id: book.id) }
  let(:cart) { FactoryBot.create(:cart, quantity: 1) }
  let(:user) { cart_book.cart.user }
  let(:book) { FactoryBot.create(:book, quantity: 1) }
  let(:borrow_params) do
    { borrow_address: { postal_code: "123-4567", prefecture_id: "1", city: "test", street_address: "test", detail_address: "test", phone_number: "09012345678", book_ids: [book.id] } }
  end
  let(:invalid_borrow_params) do
    { borrow_address: { postal_code: "" } }
  end
  let(:admin) { FactoryBot.create(:user, :a) }
  let!(:borrow_book) {FactoryBot.create(:borrow_book) }
  let(:borrow) { borrow_book.borrow }
  let(:borrow_user) { borrow_book.borrow.user }
  let!(:borrow_user_cart) { FactoryBot.create(:cart, user_id: borrow_user.id) }
  
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

  describe 'POST #create' do
    before do
      sign_in(user)
    end

    context '保存に成功した場合'do
      it 'createアクションにレスポンスすると正常にレスポンスが返ってきている' do
        post user_borrows_path(user), params: borrow_params 
        expect(response.status).to eq 302
      end
      it 'Borrowsテーブルに保存ができた' do
        expect { post user_borrows_path(user), params: borrow_params }.to change(Borrow, :count).by(1)
      end
      it 'Addressesテーブルに保存ができた' do
        expect { post user_borrows_path(user), params: borrow_params }.to change(Address, :count).by(1)
      end
      it 'Cartsテーブルのquantityが０になった' do
        post user_borrows_path(user), params: borrow_params
        expect(cart.reload.quantity).to eq(0)
      end
      it 'Cartsテーブルのquantityが０になった' do
        post user_borrows_path(user), params: borrow_params
        expect(cart.reload.quantity).to eq(0)
      end
      it 'CartBookが削除された' do
        expect { post user_borrows_path(user), params: borrow_params }.to change(CartBook, :count).by(-1)
      end
      it 'トップページに遷移すること' do
        post user_borrows_path(user), params: borrow_params
        expect(response).to redirect_to root_path
      end
    end
    context '保存に失敗した場合' do
      it 'createアクションにレスポンスすると正常にレスポンスが返ってきていない' do
        post user_borrows_path(user), params: invalid_borrow_params 
        expect(response.status).not_to eq 302
      end
      it 'Borrowsテーブルに保存ができていない' do
        expect { post user_borrows_path(user), params: invalid_borrow_params }.not_to change(Borrow, :count)
      end
      it 'Addressesテーブルに保存ができていない' do
        expect { post user_borrows_path(user), params: invalid_borrow_params }.not_to change(Address, :count)
      end
      it 'Cartsテーブルのquantityが０になったいない' do
        post user_borrows_path(user), params: invalid_borrow_params
        expect(cart.reload.quantity).not_to eq(0)
      end
      it 'CartBookが削除されていない' do
        expect { post user_borrows_path(user), params: invalid_borrow_params }.not_to change(CartBook, :count)
      end
      it 'エラーメッセージが表示されている' do
        post user_borrows_path(user), params: invalid_borrow_params
        expect(response.body).to include("error-message")
      end
    end
  end

  describe 'PUT #update' do
    before do
      sign_in(admin)
    end

    it 'updateアクションにレスポンスすると正常にレスポンスが返ってきている' do
      put user_borrow_path(borrow_user, borrow)
      expect(response.status).to eq 302
    end
    it 'データベースが更新している' do
      put user_borrow_path(borrow_user, borrow), params: { user_id: borrow_user.id }
      expect(borrow.reload.borrowing_book).to eq(false)
    end
    it 'Borrowsテーブルが増減していない' do
      expect { put user_borrow_path(borrow_user, borrow) }.not_to change(Borrow, :count)
    end
    it 'ユーザー一覧に遷移していること' do
      put user_borrow_path(user, borrow)
      expect(response).to redirect_to users_path
    end
  end

  describe 'GET #index' do
    context '管理者ユーザーでログインした場合' do
      before do
        sign_in(admin)
      end

      it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do
        get user_borrows_path(borrow_user)
        expect(response.status).to eq 200
      end
      it 'indexアクションにリクエストするとレスポンスに過去に借りた本の画像が存在する' do
        get user_borrows_path(borrow_user)
        expect(response.body).to include('card-img-left')
      end
      it 'indexアクションにリクエストするとレスポンスに過去に借りた本のタイトルが存在する' do
        get user_borrows_path(borrow_user)
        expect(response.body).to include(borrow_book.book.title)
      end
      it 'indexアクションにリクエストするとレスポンスに過去に借りた本の作者が存在する' do
        get user_borrows_path(borrow_user)
        expect(response.body).to include(borrow_book.book.author)
      end
      it 'indexアクションにリクエストするとレスポンスに過去に借りた本のカテゴリーが存在する' do
        get user_borrows_path(borrow_user)
        expect(response.body).to include(borrow_book.book.category.name)
      end
    end
    context '一般ユーザーでログインした場合' do
      before do
        sign_in(borrow_user)
      end

      it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do
        get user_borrows_path(borrow_user)
        expect(response.status).to eq 200
      end
      it 'indexアクションにリクエストするとレスポンスに過去に借りた本の画像が存在する' do
        get user_borrows_path(borrow_user)
        expect(response.body).to include('card-img-left')
      end
      it 'indexアクションにリクエストするとレスポンスに過去に借りた本のタイトルが存在する' do
        get user_borrows_path(borrow_user)
        expect(response.body).to include(borrow_book.book.title)
      end
      it 'indexアクションにリクエストするとレスポンスに過去に借りた本の作者が存在する' do
        get user_borrows_path(borrow_user)
        expect(response.body).to include(borrow_book.book.author)
      end
      it 'indexアクションにリクエストするとレスポンスに過去に借りた本のカテゴリーが存在する' do
        get user_borrows_path(borrow_user)
        expect(response.body).to include(borrow_book.book.category.name)
      end
    end
    context 'ログアウト状態の場合' do
      it 'indexアクションにリクエストすると正常にレスポンスが返っていない' do
        get user_borrows_path(borrow_user)
        expect(response.status).not_to eq 200
      end
      it 'ログインページに遷移すること' do
        get user_borrows_path(borrow_user)
        expect(response).to redirect_to new_user_session_path 
      end
    end
  end
end
