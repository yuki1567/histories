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
      expect {
        find('input[name="commit"]').click
      }.to change { Borrow.count }.by(1).and change { Address.count }.by(1)
      # トップページに遷移することを確認する
      expect(current_path).to eq(root_path)
    end
  end

  context '本を借りることができない場合' do
    it "誤った情報では本を借りることができない" do
      # ログインする
      sign_in(user)
      # 貸し出しページに移動する
      visit new_user_borrow_path(user)
      # 配達先情報を入力する
      fill_in '郵便番号', with: ""
      # 本を借りるボタンを押すとBorrrowモデルとAddressモデルのカウントが変わらないことを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { Borrow.count }.by(0).and change { Address.count }.by(0)
      # 本貸し出しページに遷移することを確認する
      expect(current_path).to eq(user_borrows_path(user))
    end
  end

  context '本を借りることができない場合' do
    let!(:borrow) { FactoryBot.create(:borrow, user_id: user.id) }
    it "すでに本を借りている場合は本を借りられない" do
      # ログインする
      sign_in(user)
      # カートページに移動する
      visit user_cart_path(user, cart)
      # 確認画面に進むボタンを押す
      click_on("確認画面に進む")
      # カートページに遷移していることを確認する
      expect(current_path).to eq(user_cart_path(user, cart))
    end
  end
end