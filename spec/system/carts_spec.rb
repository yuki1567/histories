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
      # カートに入れるを押すとCartBookモデルのカウントが１増えることを確認する
      expect do
        find('input[value="カートに入れる"]').click
      end.to change { CartBook.count }.by(1)
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
      # # カートに入れるを押すとCartBookモデルのカウントが上がらないことを確認する
      expect do
        find('.cart-btn').click
      end.to change { CartBook.count }.by(0)
      # ログインページに遷移することを確認する
      expect(current_path).to eq(new_user_session_path)
    end
    it 'カートの本が10冊以上では本の追加ができない' do
      # ログインする
      sign_in(user)
      # 本詳細ページに移動する
      visit book_path(book)
      # カートに入れるを押すとCartBookモデルのカウントが上がらないことを確認する
      expect do
        find('input[value="カートに入れる"]').click
      end.to change { CartBook.count }.by(0)
      # 本詳細ページに遷移していることを確認する
      expect(current_path).to eq(user_carts_path(user))
    end
    it 'カートの中に同じ本があると本の追加ができない' do
      # ログインする
      sign_in(user)
      # 本詳細ページに移動する
      visit book_path(book)
      # カートに入れるを押すとCartBookモデルのカウントが上がらないことを確認する
      expect do
        find('input[value="カートに入れる"]').click
      end.to change { CartBook.count }.by(0)
      # 本詳細ページに遷移していることを確認する
      expect(current_path).to eq(user_carts_path(user))
    end
  end
end

RSpec.describe 'カート詳細' do
  let(:cart_book) { FactoryBot.create(:cart_book) }
  let(:cart) { cart_book.cart }
  let(:user) { cart_book.cart.user }

  context 'カートページに遷移できる場合' do
    it 'ログインしているユーザーなら自身のカートページに遷移できる' do
      # ログインする
      sign_in(user)
      # カートページに遷移するボタンがあることを確認する
      expect(page).to have_selector('.bi-cart-fill')
      # カートページに移動する
      visit user_cart_path(user, cart)
      # カートに追加した本の情報が表示されていることを確認する
      expect(page).to have_selector('img')
      expect(page).to have_content(cart_book.book.title)
      expect(page).to have_content(cart_book.book.author)
      expect(page).to have_selector('.category-name')
      # 詳細、削除ボタンがあることを確認する
      expect(page).to have_content('詳細')
      expect(page).to have_content('削除')
      # 本貸し出しページに遷移するボタンがあることを確認する
      expect(page).to have_content('確認画面に進む')
    end
  end
  context 'カートページに遷移できない場合' do
    it 'ログアウト状態ではカートページに遷移できない' do
      # トップページに移動する
      visit root_path
      # カートページに遷移するボタンを押す
      click_on('cart-btn')
      # ログインページに遷移することを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

RSpec.describe 'カートの本の削除' do
  let(:cart_book) { FactoryBot.create(:cart_book) }
  let(:cart) { cart_book.cart }
  let(:user) { cart_book.cart.user }
  let(:book) { cart_book.book }

  it 'ログインしていればカートの本を削除できる' do
    # ログインする
    sign_in(user)
    # カートページに移動する
    visit user_cart_path(user, cart)
    # 削除ボタンがあることを確認する
    expect(page).to have_content('削除')
    # 削除ボタンを押すとCartBookモデルのレコードが１減ることを確認する
    expect do
      find_link('削除').click
    end.to change { CartBook.count }.by(-1)
    # カートページに遷移することを確認する
    expect(current_path).to eq(user_cart_path(user, cart))
    # カートの中の本が削除されていることを確認する
    expect(page).to have_no_content(book.title)
  end
end
