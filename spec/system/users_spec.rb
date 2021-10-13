require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :system do
  let(:user) { FactoryBot.build(:user, :b) }

  context 'ユーザー新規登録ができる場合' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページに移動する
      visit root_path
      # トップページに新規登録ページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページに移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in '名前', with: user.name
      fill_in 'フリガナ', with: user.kana_name
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      fill_in 'パスワード（確認用）', with: user.password_confirmation
      # 登録ボタンを押すとUserモデルのカウントが１上がることを確認する
      expect  do
        find('input[name="commit"]').click
      end.to change { User.count }.by(1)
      # トップページに遷移したことを確認する
      expect(current_path).to eq(root_path)
      # マイページへ遷移するボタンやログアウトボタンが表示されることを確認する
      expect(page).to have_content('マイページ')
      expect(page).to have_content('ログアウト')
      # 新規登録ページへ遷移するボタンやログアウトボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ユーザー新規登録ができない場合' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページに戻ってくる' do
      # トップページに移動する
      visit root_path
      # トップページに新規登録ページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページに移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in '名前', with: ''
      fill_in 'フリガナ', with: ''
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: ''
      fill_in 'パスワード（確認用）', with: ''
      # 登録ボタンを押してもUserモデルのカウントは上がらないことを確認する
      expect  do
        find('input[name="commit"]').click
      end.to change { User.count }.by(0)
      # 新規登録ページに遷移したことを確認する
      expect(current_path).to eq(user_registration_path)
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  let(:admin) { FactoryBot.create(:user, :a) }
  let(:cart) { FactoryBot.create(:cart) }
  let(:user) { cart.user }

  context 'ログインできる場合' do
    it '保存されている管理者ユーザーの情報と合致すればログインできる' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページに移動する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'メールアドレス', with: admin.email
      fill_in 'パスワード', with: admin.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページに遷移したことを確認する
      expect(current_path).to eq(root_path)
      # マイページへ遷移するボタンやログアウトボタンが表示されることを確認する
      expect(page).to have_content('本の登録')
      expect(page).to have_content('ユーザー一覧')
      expect(page).to have_content('ログアウト')
      # 新規登録ページへ遷移するボタンやログアウトボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
    it '保存されている一般ユーザーの情報と合致すればログインできる' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページに移動する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページに遷移したことを確認する
      expect(current_path).to eq(root_path)
      # マイページへ遷移するボタンやログアウトボタンが表示されることを確認する
      expect(page).to have_content('マイページ')
      expect(page).to have_content('ログアウト')
      # 新規登録ページへ遷移するボタンやログアウトボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ログインできないとき' do
    it '登録されているユーザーの情報と合致しないとログインできない' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページに移動する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: ''
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページに遷移したことを確認する
      expect(current_path).to eq(user_session_path)
    end
  end
end

RSpec.describe 'ユーザー一覧', type: :system do
  let(:admin) { FactoryBot.create(:user, :a) }
  let(:cart) { FactoryBot.create(:cart) }
  let!(:user) { cart.user }

  context 'ユーザー一覧が見られる場合' do
    it '管理者ユーザーでログイン状態ならばユーザー一覧が見られる' do
      # ログインする
      sign_in(admin)
      # トップページに移動する
      visit root_path
      # ユーザー一覧のリンクを押す
      click_on("ユーザー一覧")
      # ユーザー一覧ページに遷移していることを確認する
      expect(current_path).to eq(users_path)
      # ユーザー情報が表示されていることを確認する
      expect(page).to have_content(user.name)
      expect(page).to have_content(user.kana_name)
      expect(page).to have_content(user.email)
      # 編集、削除ボタンが表示されていることを確認する
      expect(page).to have_content("編集")
      expect(page).to have_content("削除")
    end
  end
  context 'ユーザー一覧が見られない場合' do
    it '一般ユーザーでログイン状態ではユーザー一覧が見られない' do
      # ログインする
      sign_in(user)
      # ユーザー一覧ページに移動する
      visit users_path
      # トップページに遷移していることを確認する
      expect(current_path).to eq(root_path)
    end
    it 'ログアウト状態ではユーザー一覧が見られない' do
      # ユーザー一覧ページに移動する
      visit users_path
      # トップページに遷移していることを確認する
      expect(current_path).to eq(root_path)
    end
  end
end
