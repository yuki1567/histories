require 'rails_helper'

RSpec.describe 'Carts', type: :request do
  let(:cart_book) { FactoryBot.create(:cart_book) }
  let(:cart) { cart_book.cart }
  let(:user) { cart_book.cart.user }
  let(:book) { FactoryBot.create(:book) }
  let(:cart_params) do
    { quantity: 1, book_id: book.id, art_book_id: cart_book.id, cart_id: cart.id }
  end
  let(:invalid_cart_params) do
    { quantity: 11, book_id: book.id }
  end
  let(:another_cart) { FactoryBot.create(:cart) }
  let(:another_user) { another_cart.user }

  describe 'POST #create' do
    before do
      sign_in(user)
    end
    context '保存に成功した場合' do
      it 'createアクションにレスポンスすると正常にレスポンスが返ってきている' do
        post user_carts_path(user), params: cart_params
        expect(response.status).to eq 302
      end
      it 'データベースが更新している' do
        post user_carts_path(user), params: cart_params
        expect(cart.reload.quantity).to eq(1)
      end
      it 'Cartsテーブルのカウントが増減していない' do
        expect { post user_carts_path(user), params: cart_params }.not_to change(Cart, :count)
      end
      it 'CartBooksテーブルに保存ができている' do
        expect { post user_carts_path(user), params: cart_params }.to change(CartBook, :count).by(1)
      end
      it 'トップページに遷移すること' do
        post user_carts_path(user), params: cart_params
        expect(response).to redirect_to root_path
      end
    end

    context '保存に失敗した場合' do
      it 'データベースが更新していない' do
        post user_carts_path(user), params: invalid_cart_params
        expect(cart.reload.quantity).not_to eq(11)
      end
      it 'Cartsテーブルのカウントが増減していない' do
        expect { post user_carts_path(user), params: invalid_cart_params }.not_to change(Cart, :count)
      end
      it 'CartBookテーブルに保存ができていない' do
        expect { post user_carts_path(user), params: invalid_cart_params }.not_to change(CartBook, :count)
      end
      it 'エラーメッセージが表示されている' do
        post user_carts_path(user), params: invalid_cart_params
        expect(response.body).to include('error-message')
      end
    end
  end

  describe 'GET #show' do
    context 'ログイン状態の場合' do
      before do
        sign_in(user)
      end

      it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
        get user_cart_path(user, cart)
        expect(response.status).to eq 200
      end
      it 'showアクションにリクエストするとレスポンスにカートに入れた本の画像が存在する' do
        get user_cart_path(user, cart)
        expect(response.body).to include('card-img-left')
      end
      it 'showアクションにリクエストするとレスポンスにカートに入れた本のタイトルが存在する' do
        get user_cart_path(user, cart)
        expect(response.body).to include(cart_book.book.title)
      end
      it 'showアクションにリクエストするとレスポンスにカートに入れた本の作者が存在する' do
        get user_cart_path(user, cart)
        expect(response.body).to include(cart_book.book.author)
      end
      it 'showアクションにリクエストするとレスポンスにカートに入れた本のカテゴリーが存在する' do
        get user_cart_path(user, cart)
        expect(response.body).to include(cart_book.book.category.name)
      end
    end

    context 'ログイン状態で他のユーザーのカートページに遷移しようとした場合' do
      before do
        sign_in(another_user)
      end

      it 'showアクションにリクエストすると正常にレスポンスが返ってきていない' do
        get user_cart_path(user, cart)
        expect(response.status).not_to eq 200
      end
      it 'トップページに遷移すること' do
        get user_cart_path(user, cart)
        expect(response).to redirect_to root_path
      end
    end

    context 'ログアウト状態の場合' do
      it 'showアクションにリクエストすると正常にレスポンスが返ってきていない' do
        get user_cart_path(user, cart)
        expect(response.status).not_to eq 200
      end
      it 'ログインページに遷移すること' do
        get user_cart_path(user, cart)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      sign_in(user)
    end

    it 'destroyアクションにレスポンスすると正常にレスポンスが返ってきている' do
      delete user_cart_path(user, cart), params: { book_id: cart_book.book.id }
      expect(response.status).to eq 302
    end
    it 'データベースが更新している' do
      delete user_cart_path(user, cart), params: { book_id: cart_book.book.id }
      expect(cart.reload.quantity).to eq(-1)
    end
    it 'Cartsテーブルのカウントが増減していない' do
      expect { delete user_cart_path(user, cart), params: { book_id: cart_book.book.id } }.not_to change(Cart, :count)
    end
    it 'データベースから削除されている' do
      expect do
        delete user_cart_path(user, cart), params: { book_id: cart_book.book.id }
      end.to change(CartBook, :count).by(-1)
    end
    it 'カートページに遷移すること' do
      delete user_cart_path(user, cart), params: { book_id: cart_book.book.id }
      expect(response).to redirect_to user_cart_path(user, cart)
    end
  end
end
