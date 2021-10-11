require 'rails_helper'

RSpec.describe 'カートに本の追加', type: :system do
  let(:cart) { FactoryBot.create(:cart) }
  let(:user) { cart.user }
  let(:book) { FactoryBot.create(:book) }

  context 'カートに本の追加ができる場合' do
    it 'ログイン状態なら本の追加ができる' do
      # ログインする
      sign_in(user)
      # 本詳細ページに移動する
      visit book_path(book)
      # カートに入れるを押すとCartモデルのカウントが変わらないこととCartBookモデルのカウントが１増えることを確認する
      expect{
        find('input[value="カートに入れる"]').click
      }.to change { Cart.count }.by(0).and change { CartBook.count }.by(1)
      # トップページに遷移したことを確認する
      expect(current_path).to eq(root_path)
      # カートページに移動する
      visit user_cart_path(user, cart)
      # カートに本が追加されていることを確認する
      expect(page).to have_content(book.title)
    end
  end
  context 'カートに本の追加ができない場合' do
    let(:book) { FactoryBot.create(:book) }
    let!(:cart) { FactoryBot.create(:cart, quantity: 10) }
    let!(:user) { cart.user }
    let!(:cart_book) { FactoryBot.create(:cart_book, cart_id: cart.id, book_id: book.id) }

    it 'ログアウト状態では本の追加はできない' do
      # 本の詳細ページに移動する
      visit book_path(book)
      # # カートに入れるを押すとCartモデルとCartBookモデルのカウントが上がらないことを確認する
      expect{
        find(".cart-btn").click
      }.to change { Cart.count }.by(0).and change { CartBook.count }.by(0)
      # ログインページに遷移することを確認する
      expect(current_path).to eq(new_user_session_path)
    end
    it 'カートの本が10冊以上では本の追加ができない' do
      # ログインする
      sign_in(user)
      # 本詳細ページに移動する
      visit book_path(book)
      # カートに入れるを押すとCartモデルとCartBookモデルのカウントが上がらないことを確認する
      expect{
        find('input[value="カートに入れる"]').click
      }.to change { Cart.count }.by(0).and change { CartBook.count }.by(0)
      # 本詳細ページに遷移していることを確認する
      expect(current_path).to eq(user_carts_path(user))
    end
    it 'カートの中に同じ本があると本の追加ができない' do
      # ログインする
      sign_in(user)
      # 本詳細ページに移動する
      visit book_path(book)
      # カートに入れるを押すとCartモデルとCartBookモデルのカウントが上がらないことを確認する
      expect{
        find('input[value="カートに入れる"]').click
      }.to change { Cart.count }.by(0).and change { CartBook.count }.by(0)
      # 本詳細ページに遷移していることを確認する
      expect(current_path).to eq(user_carts_path(user))
    end
  end
end