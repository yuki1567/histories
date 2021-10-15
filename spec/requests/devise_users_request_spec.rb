require 'rails_helper'

RSpec.describe 'UsersRegistration', type: :request do
  let(:user_params) do
    {  user: { email: 'a@com', password: 'password', password_confirmation: 'password', name: '山田', kana_name: 'ヤマダ',
               cart_attributes: 1 } }
  end
  let(:invalid_user_params) do
    {  user: { email: '', password: 'password', password_confirmation: 'password', name: '山田', kana_name: 'ヤマダ',
               cart_attributes: 1 } }
  end

  describe 'GET #new' do
    it 'newアクションにリクエストすると正常にレスポンスが返ってきている' do
      get new_user_registration_path
      expect(response.status).to eq 200
    end
    it 'newアクションにリクエストするとレスポンスに本登録フォームが存在する' do
      get new_user_registration_path
      expect(response.body).to include('登録')
    end
  end

  describe 'POST #create' do
    context '保存に成功した場合' do
      it 'createアクションにレスポンスすると正常にレスポンスが返ってきている' do
        post user_registration_path, params: user_params
        expect(response.status).to eq 302
      end
      it 'データベースに保存ができている' do
        expect { post user_registration_path, params: user_params }.to change(User, :count).by(1)
      end
      it 'トップページに遷移すること' do
        post user_registration_path, params: user_params
        expect(response).to redirect_to root_path
      end
    end
    context '保存に失敗した場合' do
      it 'createアクションにレスポンスすると正常にレスポンスが返ってきていない' do
        post user_registration_path, params: invalid_user_params
        expect(response.status).not_to eq 302
      end
      it 'データベースに保存ができていない' do
        expect { post user_registration_path, params: invalid_user_params }.not_to change(User, :count)
      end
      it 'エラーメッセージが表示されている' do
        post user_registration_path, params: invalid_user_params
        expect(response.body).to include('error-message')
      end
    end
  end
end

RSpec.describe 'UsersSession', type: :request do
  let!(:user) { FactoryBot.create(:user, :b) }
  let(:session_params) do
    { user: { email: user.email, password: user.password } }
  end
  let(:invalid_session_params) do
    { user: { email: '', password: user.password } }
  end

  describe 'GET #new' do
    it 'newアクションにリクエストすると正常にレスポンスが返ってきている' do
      get new_user_session_path
      expect(response.status).to eq 200
    end
    it 'newアクションにリクエストするとレスポンスに本登録フォームが存在する' do
      get new_user_session_path
      expect(response.body).to include('登録')
    end
  end

  describe 'POST #create' do
    context 'ログインに成功した場合' do
      it 'createアクションにレスポンスすると正常にレスポンスが返ってきている' do
        post user_session_path, params: session_params
        expect(response.status).to eq 302
      end
      it 'トップページに遷移すること' do
        post user_session_path, params: session_params
        expect(response).to redirect_to root_path
      end
    end
    context ' ログインに失敗した場合' do
      it 'createアクションにレスポンスすると正常にレスポンスが返ってきていない' do
        post user_session_path, params: invalid_session_params
        expect(response.status).not_to eq 302
      end
      it 'エラーメッセージが表示されている' do
        post user_session_path, params: invalid_session_params
        expect(response.body).to include('login-flash-message')
      end
    end
  end
end
