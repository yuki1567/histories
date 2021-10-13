require 'rails_helper'

RSpec.describe '本を借りる', type: :system do
  let!(:cart_book) { FactoryBot.create(:cart_book) }
  let(:cart) { cart_book.cart }
  let(:user) { cart_book.cart.user }
  let(:borrow_address) { FactoryBot.build(:borrow_address, user_id: user.id) }

  context '本を借りることができる場合' do
    it '正しい情報を入力すれば本を借りることができる' do
      # ログインする
      sign_in(user)
      # 貸し出しページに移動する
      visit new_user_borrow_path(user)
      # 配達先情報を入力する
      fill_in '郵便番号', with: borrow_address.postal_code
      select Prefecture.data[borrow_address.prefecture_id - 1][:name], from: 'prefecture'
      fill_in '市区町村', with: borrow_address.city
      fill_in '番地', with: borrow_address.street_address
      fill_in '建物名', with: borrow_address.detail_address
      fill_in '電話番号', with: borrow_address.phone_number
      # 本を借りるボタンを押すとBorrrowモデルとAddressモデルのカウントが１上げることを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Borrow.count }.by(1).and change { Address.count }.by(1)
      # トップページに遷移することを確認する
      expect(current_path).to eq(root_path)
    end
  end

  context '本を借りることができない場合' do
    it '誤った情報では本を借りることができない' do
      # ログインする
      sign_in(user)
      # 貸し出しページに移動する
      visit new_user_borrow_path(user)
      # 配達先情報を入力する
      fill_in '郵便番号', with: ''
      # 本を借りるボタンを押すとBorrrowモデルとAddressモデルのカウントが変わらないことを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Borrow.count }.by(0).and change { Address.count }.by(0)
      # 本貸し出しページに遷移することを確認する
      expect(current_path).to eq(user_borrows_path(user))
    end
  end

  context '本を借りることができない場合' do
    let!(:borrow) { FactoryBot.create(:borrow, user_id: user.id) }
    it 'すでに本を借りている場合は本を借りられない' do
      # ログインする
      sign_in(user)
      # カートページに移動する
      visit user_cart_path(user, cart)
      # 確認画面に進むボタンを押す
      click_on('確認画面に進む')
      # カートページに遷移していることを確認する
      expect(current_path).to eq(user_cart_path(user, cart))
    end
  end
end

RSpec.describe '本の返却を確認', type: :system do
  let(:admin) { FactoryBot.create(:user, :a) }
  let(:cart) { FactoryBot.create(:cart) }
  let(:user) { cart.user }
  let!(:borrow) { FactoryBot.create(:borrow, user_id: user.id) }

  context '本の返却を確認できる場合' do
    it '管理者ユーザーでログイン状態ならば本の返却を確認できる' do
      # ログインする
      sign_in(admin)
      # 一般ユーザーのマイページに移動する
      visit user_path(user)
      # 返却確認済みのボタンがあることを確認する
      expect(page).to have_content('返却確認済み')
      # 返却確認済みを押してもBorrowモデルのカウントが変わらないことを確認する
      expect do
        find_link('返却確認済み').click
      end.to change { Borrow.count }.by(0)
      # ユーザー一覧に遷移する
      expect(current_path).to eq(users_path)
      # 貸し出し中が表示されていないことを確認する
      expect(page).to have_no_content('貸し出し中')
    end
  end
  context '本の返却確認できない場合' do
    it '一般ユーザーでログイン状態では本の返却を確認できない' do
      # ログインする
      sign_in(user)
      # マイページに移動する
      visit user_path(user)
      # 返却確認済みのボタンがないことを確認する
      expect(page).to have_no_content('返却確認済み')
    end
  end
end

RSpec.describe '借りた本の履歴' do
  let(:admin) { FactoryBot.create(:user, :a) }
  let!(:borrow_book) { FactoryBot.create(:borrow_book) }
  let(:book) { borrow_book.book }
  let(:user) { borrow_book.borrow.user }
  let!(:cart) { FactoryBot.create(:cart, user_id: user.id) }
  let!(:another_cart) { FactoryBot.create(:cart) }
  let(:another_user) { another_cart.user }

  context '借りた本の履歴を見られる場合' do
    it '管理者ユーザーでログインしていれば借りた本の履歴を見られる' do
      # ログインする
      sign_in(admin)
      # 一般ユーザーのマイページに移動する
      visit user_path(user)
      # 借りた本の履歴を押す
      click_on('借りた本の履歴')
      # 借りた本の履歴ページに遷移していることを確認する
      expect(current_path).to eq(user_borrows_path(user))
      # 借りた本の情報が表示されていることを確認する
      expect(page).to have_selector('img')
      expect(page).to have_content(book.title)
      expect(page).to have_content(book.author)
      expect(page).to have_selector('.category-name')
    end
    it '一般ユーザーでログインしていれば自身の借りた本の履歴を見られる' do
      # ログインする
      sign_in(user)
      # マイページに移動する
      visit user_path(user)
      # 借りた本の履歴を押す
      click_on('借りた本の履歴')
      # 借りた本の履歴ページに遷移していることを確認する
      expect(current_path).to eq(user_borrows_path(user))
      # 借りた本の情報が表示されていることを確認する
      expect(page).to have_selector('img')
      expect(page).to have_content(book.title)
      expect(page).to have_content(book.author)
      expect(page).to have_selector('.category-name')
    end
  end
  context '本の借りた履歴を見られない場合' do
    it 'ログイン状態でも他のユーザーの借りた本の履歴は見られない' do
      # ログインする
      sign_in(another_user)
      # 他のユーザーの借りた本の履歴ページにに移動する
      visit user_borrows_path(user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq(root_path)
    end
    it 'ログアウト状態では見られない' do
      # 本の履歴ページに移動する
      visit user_borrows_path(user)
      # ログインページに遷移することを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end
