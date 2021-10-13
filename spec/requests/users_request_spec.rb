require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:admin) { FactoryBot.create(:user, :a)}
  let!(:cart) { FactoryBot.create(:cart) }
  let(:user) { cart.user }
  let(:borrow) { FactoryBot.create(:borrow, user_id: user.id) }
  let!(:borrow_book) { FactoryBot.create(:borrow_book, borrow_id: borrow.id) }
  let(:user_params) do
    { user: { name: "山田" } }
  end
  let(:invalid_user_params) do
    { user: { name: "" } }
  end

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

  describe 'GET #edit' do
    context '管理者ユーザーでログイン状態の場合' do
      before do
        sign_in(admin)
      end
      
      it 'editアクションにリクエストすると正常にレスポンスが返ってくる' do
        get edit_user_path(user)
        expect(response.status).to eq 200
      end
      it 'editアクションにリクエストするとレスポンスに本編集フォームが存在する' do
        get edit_user_path(user)
        expect(response.body).to include('変更')
      end
    end
    context '一般ユーザーでログイン状態の場合' do
      before do
        sign_in(user)
      end
      it 'editアクションにリクエストすると正常にレスポンスが返ってきている' do
        get edit_user_path(user)
        expect(response.status).to eq 200
      end
      it 'editアクションにリクエストするとレスポンスに本編集フォームが存在する' do
        get edit_user_path(user)
        expect(response.body).to include('変更')
      end
    end
    context 'ログアウト状態の場合' do
      it 'editアクションにリクエストすると正常にレスポンスが返ってきていない' do
        get edit_user_path(user)
        expect(response.status).not_to eq 200
      end
      it 'トップページに遷移すること' do
        get edit_user_path(user)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PUT #update' do
    before do
      sign_in(user)
    end

    context '保存に成功した場合' do
      it 'updateアクションにレスポンスすると正常にレスポンスが返ってきている' do
        put user_path(user), params: user_params
        expect(response.status).to eq 302
      end
      it 'データベースが更新している' do
        put user_path(user), params: user_params
        expect(user.reload.name).to eq('山田')
      end
      it 'Booksテーブルが増減していない' do
        expect { put user_path(user), params: user_params }.not_to change(User, :count)
      end
      it 'マイページに遷移すること' do
        put user_path(user), params: user_params
        expect(response).to redirect_to user_path(user)
      end
    end
    context '保存に失敗した場合' do
      it 'updateアクションにレスポンスすると正常にレスポンスが返ってきていない' do
        put user_path(user), params: invalid_user_params
        expect(response.status).not_to eq 302
      end
      it 'データベースが更新していない' do
        put user_path(user), params: invalid_user_params
        expect(user.reload.name).not_to eq('山田')
      end
      it 'Booksテーブルが増減していない' do
        expect { put user_path(user), params: invalid_user_params }.not_to change(User, :count)
      end
      it 'エラーメッセージが表示されていること' do
        put user_path(user), params: invalid_user_params
        expect(response.body).to include("error-message")
      end
    end
  end

  describe 'DELETE #destroy' do
    context '管理者ユーザーでログインした場合' do
      before do
        sign_in(admin)
      end
      it 'destroyアクションにレスポンスすると正常にレスポンスが返ってきている' do
        delete user_path(user), params: { id: user.id }
        expect(response.status).to eq 302
      end
      it 'データベースから削除されている' do
        expect do
          delete user_path(user), params: { id: user.id }
        end.to change(User, :count).by(-1)
      end
      it 'ユーザー一覧ページに遷移すること' do
        delete user_path(user), params: { id: user.id }
        expect(response).to redirect_to users_path
      end
    end
    context '一般ユーザーでログインした場合' do
      before do
        sign_in(user)
      end
      it 'データベースから削除されていない' do
        expect do
          delete user_path(user), params: { id: user.id }
        end.to change(User, :count).by(0)
      end
      it 'トップページに遷移すること' do
        delete user_path(user), params: { id: user.id }
        expect(response).to redirect_to root_path
      end
    end
    context 'ログインアウト状態の場合' do
      it 'データベースから削除されていない' do
        expect do
          delete user_path(user), params: { id: user.id }
        end.to change(User, :count).by(0)
      end
      it 'トップページに遷移すること' do
        delete user_path(user), params: { id: user.id }
        expect(response).to redirect_to root_path
      end
    end
  end
end
