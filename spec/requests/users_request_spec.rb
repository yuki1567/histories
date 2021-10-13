require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:admin) { FactoryBot.create(:user, :a)}
  let!(:cart) { FactoryBot.create(:cart) }
  let(:user) { cart.user }
  let(:borrow) { FactoryBot.create(:borrow, user_id: user.id) }
  let!(:borrow_book) { FactoryBot.create(:borrow_book, borrow_id: borrow.id) }

  describe 'GET #index' do
    context '管理者ユーザでログイン状態の場合' do
      before do
        sign_in(admin)
      end
      it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do
        get users_path
        expect(response.status).to eq 200
      end
      it 'indexアクションにリクエストするとレスポンスに登録済みのユーザーの名前が存在する' do
        get users_path
        expect(response.body).to include(user.name)
      end
      it 'indexアクションにリクエストするとレスポンスに登録済みのユーザーのフリガナが存在する' do
        get users_path
        expect(response.body).to include(user.kana_name)
      end
      it 'indexアクションにリクエストするとレスポンスに登録済みの本のメールアドレスが存在する' do
        get users_path
        expect(response.body).to include(user.email)
      end
      it 'indexアクションにリクエストするとレスポンスに本を借りている場合は貸し出し中が表示されている' do
        get users_path
        expect(response.body).to include("貸し出し中")
      end
      it 'indexアクションにリクエストするとレスポンスに編集ボタンが存在する' do
        get users_path
        expect(response.body).to include('編集')
      end
      it 'indexアクションにリクエストするとレスポンスに削除ボタンが存在する' do
        get users_path
        expect(response.body).to include('削除')
      end
    end
    context '一般ユーザーでログイン状態の場合' do
      before do
        sign_in(user)
      end
      it 'indexアクションにリクエストすると正常にレスポンスが返ってきていない' do
        get users_path
        expect(response.status).not_to eq 200
      end
      it 'トップページに遷移すること' do
        get users_path
        expect(response).to redirect_to root_path
      end
    end
    context 'ログアウト状態の場合' do
      it 'indexアクションにリクエストすると正常にレスポンスが返ってきていない' do
        get users_path
        expect(response.status).not_to eq 200
      end
      it 'トップページに遷移すること' do
        get users_path
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET #show' do
    context '管理者ユーザーでログイン状態の場合' do
      before do
        sign_in(admin)
      end
  
      it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
        get user_path(user)
        expect(response.status).to eq 200
      end
      it 'showアクションにリクエストするとレスポンスに登録済みのユーザーの名前が存在する' do
        get user_path(user)
        expect(response.body).to include(user.name)
      end
      it 'showアクションにリクエストするとレスポンスに登録済みのユーザーのフリガナが存在する' do
        get user_path(user)
        expect(response.body).to include(user.kana_name)
      end
      it 'showアクションにリクエストするとレスポンスに登録済みのユーザーのメールアドレスが存在する' do
        get user_path(user)
        expect(response.body).to include(user.email)
      end
      it 'showアクションにリクエストするとレスポンスに現在借りている本の画像が存在する' do
        get user_path(user)
        expect(response.body).to include('card-img-left')
      end
      it 'showアクションにリクエストするとレスポンスに現在借りている本のタイトルが存在する' do
        get user_path(user)
        expect(response.body).to include(borrow_book.book.title)
      end
      it 'showアクションにリクエストするとレスポンスに現在借りている本の作者が存在する' do
        get user_path(user)
        expect(response.body).to include(borrow_book.book.author)
      end
      it 'showアクションにリクエストするとレスポンスに現在借りている本のカテゴリーが存在する' do
        get user_path(user)
        expect(response.body).to include(borrow_book.book.category.name)
      end
    end
    context '一般ユーザーでログイン状態の場合' do
      before do
        sign_in(user)
      end
  
      it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
        get user_path(user)
        expect(response.status).to eq 200
      end
      it 'showアクションにリクエストするとレスポンスに登録済みのユーザーの名前が存在する' do
        get user_path(user)
        expect(response.body).to include(user.name)
      end
      it 'showアクションにリクエストするとレスポンスに登録済みのユーザーのフリガナが存在する' do
        get user_path(user)
        expect(response.body).to include(user.kana_name)
      end
      it 'showアクションにリクエストするとレスポンスに登録済みのユーザーのメールアドレスが存在する' do
        get user_path(user)
        expect(response.body).to include(user.email)
      end
      it 'showアクションにリクエストするとレスポンスに現在借りている本の画像が存在する' do
        get user_path(user)
        expect(response.body).to include('card-img-left')
      end
      it 'showアクションにリクエストするとレスポンスに現在借りている本のタイトルが存在する' do
        get user_path(user)
        expect(response.body).to include(borrow_book.book.title)
      end
      it 'showアクションにリクエストするとレスポンスに現在借りている本の作者が存在する' do
        get user_path(user)
        expect(response.body).to include(borrow_book.book.author)
      end
      it 'showアクションにリクエストするとレスポンスに現在借りている本のカテゴリーが存在する' do
        get user_path(user)
        expect(response.body).to include(borrow_book.book.category.name)
      end
    end
    context 'ログアウト状態の場合' do
      it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
        get user_path(user)
        expect(response.status).not_to eq 200
      end
      it 'ログインページに遷移している' do
        get user_path(user)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
