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
    it '管理者ユーザーでログイン状態ならユーザー一覧が見られる' do
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

RSpec.describe 'マイページ', type: :system do
  let(:admin) { FactoryBot.create(:user, :a) }
  let(:cart) { FactoryBot.create(:cart) }
  let(:user) { cart.user }
  let!(:borrow) { FactoryBot.create(:borrow, borrowing_book: 1, user_id: user.id) }
  let!(:borrow_book) { FactoryBot.create(:borrow_book, borrow_id: borrow.id) }
  let(:another_cart) { FactoryBot.create(:cart) }
  let(:another_user) { another_cart.user }  

  context 'マイページを見られる場合' do
    it '管理者ユーザーでログイン状態ならマイページを見られる' do
      # ログインする
      sign_in(admin)
      # ユーザーのマイページに移動する
      visit user_path(user)
      # そのユーザーのユーザー情報が表示されている
      expect(page).to have_content(user.name)
      expect(page).to have_content(user.kana_name)
      expect(page).to have_content(user.email)
      # 登録情報の変更、借りた本の履歴、本返却確認済みボタンが表示されている
      expect(page).to have_content("登録情報の変更")
      expect(page).to have_content("借りた本の履歴")
      expect(page).to have_content("返却確認済み")
      # 現在借りている本が表示されている
      expect(page).to have_selector('img')
      expect(page).to have_content(borrow_book.book.title)
      expect(page).to have_content(borrow_book.book.author)
      expect(page).to have_selector('.category-name')
    end
    it '一般ユーザーでログイン状態なら自身のマイページを見られる' do
      # ログインする
      sign_in(user)
      # マイページに移動する
      visit user_path(user)
      # ユーザー情報が表示されている
      expect(page).to have_content(user.name)
      expect(page).to have_content(user.kana_name)
      expect(page).to have_content(user.email)
      # 登録情報の変更、借りた本の履歴ボタンが表示されていて本の返却確認済みのボタンが表示されていない
      expect(page).to have_content("登録情報の変更")
      expect(page).to have_content("借りた本の履歴")
      expect(page).to have_no_content("返却確認済み")
      # 現在借りている本が表示されている
      expect(page).to have_selector('img')
      expect(page).to have_content(borrow_book.book.title)
      expect(page).to have_content(borrow_book.book.author)
      expect(page).to have_selector('.category-name')
    end
  end
  context 'マイページを見られない場合' do
    it '一般ユーザーでログイン状態でも他のユーザーのマイページは見られない' do
      # ログインする
      sign_in(another_user)
      # 他のユーザーのマイページに移動する
      visit user_path(user)
      # トップページに遷移することを確認する
      expect(current_path).to eq(root_path)
    end
    it 'ログアウト状態ではマイページを見られない' do
      # ユーザーのマイページに移動する
      visit user_path(user)
      # トップページに遷移することを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

RSpec.describe 'ユーザー情報の編集', type: :system do
  let(:admin) { FactoryBot.create(:user, :a) }
  let(:cart) { FactoryBot.create(:cart) }
  let(:user) { cart.user }
  let(:another_cart) { FactoryBot.create(:cart) }
  let(:another_user) { another_cart.user }  

  context 'ユーザー情報を編集できる場合' do
    it '管理者ユーザーでログイン状態ならユーザー情報を編集できる' do
      # ログインする
      sign_in(admin)
      # そのユーザーのマイページに移動する
      visit user_path(user)
      # ユーザー情報変更ページへ遷移するボタンがあることを確認する
      expect(page).to have_content("登録情報の変更")
      # ユーザー情報編集ページに移動する
      visit edit_user_path(user)
      # すでに登録済みのユーザー情報が入っていることを確認する
      expect(
        find('#user_name').value
      ).to eq(user.name)
      expect(
        find('#user_kana_name').value
      ).to eq(user.kana_name)
      expect(
        find('#user_email').value
      ).to eq(user.email)
      # 登録情報を編集する
      fill_in '名前', with: "#{user.name}編集した名前"
      # 編集してもUserモデルのカウントが変わらないことを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { User.count }.by(0)
      # マイページに遷移することを確認する
      expect(current_path).to eq(user_path(user))
      # マイページに先ほど編集したユーザー情報が表示されていることを確認する
      expect(page).to have_content(user.name)
    end
    it '一般ユーザーでログイン状態なら自身のユーザー情報を編集できる' do
      # ログインする
      sign_in(user)
      # マイページに移動する
      visit user_path(user)
      # ユーザー情報変更ページへ遷移するボタンがあることを確認する
      expect(page).to have_content("登録情報の変更")
      # ユーザー情報編集ページに移動する
      visit edit_user_path(user)
      # すでに登録済みのユーザー情報が入っていることを確認する
      expect(
        find('#user_name').value
      ).to eq(user.name)
      expect(
        find('#user_kana_name').value
      ).to eq(user.kana_name)
      expect(
        find('#user_email').value
      ).to eq(user.email)
      # 登録情報を編集する
      fill_in '名前', with: "#{user.name}編集した名前"
      # 編集してもUserモデルのカウントが変わらないことを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { User.count }.by(0)
      # マイページに遷移することを確認する
      expect(current_path).to eq(user_path(user))
      # マイページに先ほど編集したユーザー情報が表示されていることを確認する
      expect(page).to have_content(user.name)
    end
  end
  context 'ユーザー情報を編集できない場合' do
    it '一般ユーザーでログイン状態でも他のユーザーの情報を編集できない' do
      # ログインする
      sign_in(another_user)
      # マイページに移動する
      visit user_path(user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq(root_path)
    end
    it 'ログアウト状態ではユーザー情報の編集はできない' do
       # マイページに移動する
       visit user_path(user)
       # トップページに遷移していることを確認する
       expect(current_path).to eq(new_user_session_path)
    end
  end
end

RSpec.describe 'ユーザーの削除', type: :system do 
  let(:admin) { FactoryBot.create(:user, :a) }
  let!(:user) { FactoryBot.create(:user, :b) }

  context 'ユーザー削除できる場合' do
    it '管理者ユーザーでログイン状態の場合ユーザー削除できる' do
      # ログインする
      sign_in(admin)
      # ユーザー一覧ページに移動する
      visit users_path
      # 削除ボタンがあることを確認する
      expect(page).to have_content("削除")
      # 削除ボタンを押すとUserモデルのカウントがい減ることを確認する
      expect {
        click_on("削除")
      }.to change { User.count}.by(-1)
      # ユーザー一覧ページに遷移したことを確認する
      expect(current_path).to eq(users_path)
      # ユーザー一覧ページに削除したユーザーの情報が存在しないことを確認する
      expect(page).to have_no_content(user.name)
    end
  end
end
