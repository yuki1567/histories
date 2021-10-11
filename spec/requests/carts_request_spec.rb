require 'rails_helper'

RSpec.describe 'Carts', type: :request do
  let(:cart_book) { FactoryBot.create(:cart_book) }
  let(:cart) { cart_book.cart }
  let(:user) { cart_book.cart.user }
  let(:book) { FactoryBot.create(:book) }
  let(:cart_params) do
    { quantity: 1, book_id: book.id }
  end
  let(:cart_book_params) do
    { cart_book_id: cart_book.id, book_id: book.id, cart_id: cart.id } 
  end
  let(:invalid_cart_params) do
    { quantity: 11, book_id: book.id } 
  end

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
      it 'Cartモデルのカウントが増減していない' do
        expect { post user_carts_path(user), params: cart_params }.not_to change(Cart, :count)
      end
      it 'CartBookテーブルに保存ができている' do
        expect { post user_carts_path(user), params: cart_book_params }.to change(CartBook, :count).by(1)
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
      it 'Cartモデルのカウントが増減していない' do
        expect { post user_carts_path(user), params: invalid_cart_params }.not_to change(Cart, :count)
      end
      it 'CartBookテーブルに保存ができていない' do
        expect { post user_carts_path(user), params: invalid_cart_params }.not_to change(CartBook, :count)
      end
      it 'エラーメッセージが表示されている' do
        post user_carts_path(user), params: invalid_cart_params
        expect(response.body).to include("error-message")
      end
    end
  end
end
