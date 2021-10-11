require 'rails_helper'

RSpec.describe '本の登録', type: :system do
  let(:admin) { FactoryBot.create(:user, :a) }
  let(:cart) { FactoryBot.create(:cart) }
  let(:user) { cart.user }
  let(:book) { FactoryBot.build(:book) }

  context '本の登録ができるとき' do
    it '管理者ユーザーでログインし、正しい情報を入力すれば本の登録ができる' do
      # ログインする
      sign_in(admin)
      # 本の登録ページへ遷移するボタンがあることを確認する
      expect(page).to have_content('本の登録')
      # 本の登録ページに移動する
      visit new_book_path
      # フォームに入力する
      attach_file('book[image]', 'public/images/test_image.png')
      fill_in 'タイトル', with: book.title
      fill_in '作者', with: book.author
      fill_in '説明', with: book.content
      select Category.data[book.category_id - 1][:name], from: 'category'
      fill_in '在庫数', with: book.quantity
      # 登録ボタンを押すとBookモデルのカウントが１上がることを確認する
      expect  do
        find('input[name="commit"]').click
      end.to change { Book.count }.by(1)
      # トップページに遷移する
      expect(current_path).to eq(root_path)
      # トップページに先ほど登録した内容の本が登録されていることを確認する
      expect(page).to have_content(book.title)
      expect(page).to have_content(book.author)
      expect(page).to have_selector('.category-name')
      expect(page).to have_content(book.quantity)
    end
  end
  context '本の登録ができないとき' do
    it '管理者ユーザーでログインしても、誤った情報では登録できない' do
      # ログインする
      sign_in(admin)
      # 本の登録ページへ遷移するボタンがあることを確認する
      expect(page).to have_content('本の登録')
      # 本の登録ページに移動する
      visit new_book_path
      # フォームに入力する
      fill_in 'タイトル', with: ''
      fill_in '作者', with: ''
      fill_in '説明', with: ''
      fill_in '在庫数', with: ''
      # 登録ボタンを押すとBookモデルのカウントが上がらないことを確認する
      expect  do
        find('input[name="commit"]').click
      end.to change { Book.count }.by(0)
      # 本登録ページに遷移したことを確認する
      expect(current_path).to eq(books_path)
    end
    it '一般ユーザーでログインした場合は本の登録ページに移動できない' do
      # ログインする
      sign_in(user)
      # 本登録ページへ遷移するボタンがないことを確認する
      expect(page).to have_no_content('本の登録')
    end
    it 'ログインしていない場合は本の登録ページに移動できない' do
      # トップページに移動する
      visit root_path
      # 本登録ページへ遷移するボタンがないことを確認する
      expect(page).to have_no_content('本の登録')
    end
  end
end

RSpec.describe '本の一覧', type: :system do
  let(:admin) { FactoryBot.create(:user, :a) }
  let(:cart) { FactoryBot.create(:cart) }
  let(:user) { cart.user }
  let!(:book) { FactoryBot.create(:book) }

  it '管理者ユーザーでログインした場合' do
    # ログインする
    sign_in(admin)
    # 一覧ページに移動する
    visit books_path
    # 本の情報が表示されている
    expect(page).to have_content(book.title)
    expect(page).to have_content(book.author)
    expect(page).to have_selector('.category-name')
    expect(page).to have_content(book.quantity)
    # 検索フォームが表示されている
    expect(page).to have_content("検索")
    # 本の登録、ユーザー一覧、ログアウトのリンクが表示されている
    expect(page).to have_content("本の登録")
    expect(page).to have_content("ユーザー一覧")
    expect(page).to have_content("ログアウト")
  end
  it '一般ユーザーでログインした場合' do
    # ログインする
    sign_in(user)
    # 一覧ページに移動する
    visit books_path
    # 本の情報が表示されている
    expect(page).to have_selector('img')
    expect(page).to have_content(book.title)
    expect(page).to have_content(book.author)
    expect(page).to have_selector('.category-name')
    # 検索フォームが表示されている
    expect(page).to have_content("検索")
    # カートボタンが表示されている
    expect(page).to have_selector('.bi-cart-fill')
    # マイページ、ログアウトのリンクが表示されている
    expect(page).to have_content("マイページ")
    expect(page).to have_content("ログアウト")
  end
  it '一般ユーザーでログインした場合' do
    # 一覧ページに移動する
    visit books_path
    # 本の情報が表示されている
    expect(page).to have_selector('img')
    expect(page).to have_content(book.title)
    expect(page).to have_content(book.author)
    expect(page).to have_selector('.category-name')
    # 検索フォームが表示されている
    expect(page).to have_content("検索")
    # カートボタンが表示されている
    expect(page).to have_selector('.bi-cart-fill')
    # ログイン、新規登録のリンクが表示されている
    expect(page).to have_content("ログイン")
    expect(page).to have_content("新規登録")
  end
end