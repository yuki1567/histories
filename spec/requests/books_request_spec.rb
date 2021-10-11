require 'rails_helper'

describe BooksController, type: :request do
  let(:admin) { FactoryBot.create(:user, :a) }
  let(:cart) { FactoryBot.create(:cart) }
  let(:user) { cart.user }
  let!(:book) { FactoryBot.create(:book) }
  let(:book_params) do
    { book: { image: fixture_file_upload('files/test_image.jpeg'), title: 'test', author: 'test', content: 'test',
      quantity: '1', category_id: '1' } }
  end
  let(:invalid_book_params) do
    { book: { title: "" } }
  end

  describe 'GET #new' do
    context '管理者ユーザーでログインした場合' do
      before do
        sign_in(admin)
      end
      it 'newアクションにリクエストすると正常にレスポンスが返ってきている' do
        get new_book_path
        expect(response.status).to eq 200
      end
      it 'newアクションにリクエストするとレスポンスに本登録フォームが存在する' do
        get new_book_path
        expect(response.body).to include('登録')
      end
    end
    context '一般ユーザーでログインした場合' do
      before do
        sign_in(user)
      end
      it 'newアクションにリクエストすると正常にレスポンスが返ってきていない' do
        get new_book_path
        expect(response.status).not_to eq 200
      end
      it 'トップページに遷移すること' do
        get new_book_path
        expect(response).to redirect_to root_path
      end
    end
    context 'ログアウト状態の場合' do
      it 'newアクションにリクエストすると正常にレスポンスが返ってきていない' do
        get new_book_path
        expect(response.status).not_to eq 200
      end
      it 'トップページに遷移すること' do
        get new_book_path
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'POST #create' do
    before do
      sign_in(admin)
    end
    context '保存に成功した場合' do
      it 'createアクションにレスポンスすると正常にレスポンスが返ってきている' do
        post books_path, params: book_params
        expect(response.status).to eq 302
      end
      it 'データベースに保存ができた' do
        expect { post books_path, params: book_params }.to change(Book, :count).by(1)
      end
      it 'トップページに遷移すること' do
        post books_path, params: book_params
        expect(response).to redirect_to root_path
      end
    end
    context '保存に失敗した場合' do
      it 'createアクションにレスポンスすると正常にレスポンスが返ってきていない' do
        post books_path, params: invalid_book_params
        expect(response.status).not_to eq 302
      end
      it 'データベースに保存ができていない' do
        expect { post books_path, params: invalid_book_params }.not_to change(Book, :count)
      end
      it 'エラーメッセージが表示されている' do
        post books_path, params: invalid_book_params
        expect(response.body).to include('error-message')
      end
    end
  end

  describe 'GET #index' do
    context '管理者ユーザーでログインした場合' do
      before do
        sign_in(admin)
      end
      it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do
        get root_path
        expect(response.status).to eq 200
      end
      it 'indexアクションにリクエストするとレスポンスに登録済みの本のタイトルが存在する' do
        get root_path
        expect(response.body).to include(book.title)
      end
      it 'indexアクションにリクエストするとレスポンスに登録済みの本の作者が存在する' do
        get root_path
        expect(response.body).to include(book.author)
      end
      it 'indexアクションにリクエストするとレスポンスに登録済みの本のカテゴリーが存在する' do
        get root_path
        expect(response.body).to include(book.category.name)
      end
      it 'indexアクションにリクエストするとレスポンスに登録済みの本の在庫数が存在する' do
        get root_path
        expect(response.body).to include(book.quantity.to_s)
      end
      it 'indexアクションにリクエストするとレスポンスに本検索フォームが存在する' do
        get root_path
        expect(response.body).to include('検索')
      end
    end
    context '一般ユーザーでログインの場合' do
      before do
        sign_in(user)
      end

      it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do
        get root_path
        expect(response.status).to eq 200
      end
      it 'indexアクションにリクエストするとレスポンスに登録済みの本の画像が存在する' do
        get root_path
        expect(response.body).to include('card-img-top')
      end
      it 'indexアクションにリクエストするとレスポンスに登録済みの本のタイトルが存在する' do
        get root_path
        expect(response.body).to include(book.title)
      end
      it 'indexアクションにリクエストするとレスポンスに登録済みの本の作者が存在する' do
        get root_path
        expect(response.body).to include(book.author)
      end
      it 'indexアクションにリクエストするとレスポンスに登録済みの本のカテゴリーが存在する' do
        get root_path
        expect(response.body).to include(book.category.name)
      end
      it 'indexアクションにリクエストするとレスポンスに本検索フォームが存在する' do
        get root_path
        expect(response.body).to include('検索')
      end
    end
    context '一般ユーザーでログインの場合' do
      it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do
        get root_path
        expect(response.status).to eq 200
      end
      it 'indexアクションにリクエストするとレスポンスに登録済みの本の画像が存在する' do
        get root_path
        expect(response.body).to include('card-img-top')
      end
      it 'indexアクションにリクエストするとレスポンスに登録済みの本のタイトルが存在する' do
        get root_path
        expect(response.body).to include(book.title)
      end
      it 'indexアクションにリクエストするとレスポンスに登録済みの本の作者が存在する' do
        get root_path
        expect(response.body).to include(book.author)
      end
      it 'indexアクションにリクエストするとレスポンスに登録済みの本のカテゴリーが存在する' do
        get root_path
        expect(response.body).to include(book.category.name)
      end
      it 'indexアクションにリクエストするとレスポンスに本検索フォームが存在する' do
        get root_path
        expect(response.body).to include('検索')
      end
    end
  end

  describe 'GET #show' do
    context '管理者ユーザーでログインした場合' do
      before do
        sign_in(admin)
      end
      it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
        get book_path(book)
        expect(response.status).to eq 200
      end
      it 'showアクションにリクエストするとレスポンスに登録済みの本の画像が存在する' do
        get book_path(book)
        expect(response.body).to include('card-img-top')
      end
      it 'showアクションにリクエストするとレスポンスに登録済みの本のタイトルが存在する' do
        get book_path(book)
        expect(response.body).to include(book.title)
      end
      it 'showアクションにリクエストするとレスポンスに登録済みの本の作者が存在する' do
        get book_path(book)
        expect(response.body).to include(book.author)
      end
      it 'showアクションにリクエストするとレスポンスに登録済みの本の説明が存在する' do
        get book_path(book)
        expect(response.body).to include(book.content)
      end
      it 'showアクションにリクエストするとレスポンスに登録済みの本のカテゴリーが存在する' do
        get book_path(book)
        expect(response.body).to include(book.category.name)
      end
      it 'showアクションにリクエストするとレスポンスに登録済みの本の在庫数が存在する' do
        get book_path(book)
        expect(response.body).to include(book.quantity.to_s)
      end
    end
    context '一般ユーザーでログインした場合' do
      before do
        sign_in(user)
      end
      it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
        get book_path(book)
        expect(response.status).to eq 200
      end
      it 'showアクションにリクエストするとレスポンスに登録済みの本の画像が存在する' do
        get book_path(book)
        expect(response.body).to include('card-img-top')
      end
      it 'showアクションにリクエストするとレスポンスに登録済みの本のタイトルが存在する' do
        get book_path(book)
        expect(response.body).to include(book.title)
      end
      it 'showアクションにリクエストするとレスポンスに登録済みの本の作者が存在する' do
        get book_path(book)
        expect(response.body).to include(book.author)
      end
      it 'showアクションにリクエストするとレスポンスに登録済みの本の説明が存在する' do
        get book_path(book)
        expect(response.body).to include(book.content)
      end
      it 'showアクションにリクエストするとレスポンスに登録済みの本のカテゴリーが存在する' do
        get book_path(book)
        expect(response.body).to include(book.category.name)
      end
    end
    context 'ログアウト状態の場合' do
      it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
        get book_path(book)
        expect(response.status).to eq 200
      end
      it 'showアクションにリクエストするとレスポンスに登録済みの本の画像が存在する' do
        get book_path(book)
        expect(response.body).to include('card-img-top')
      end
      it 'showアクションにリクエストするとレスポンスに登録済みの本のタイトルが存在する' do
        get book_path(book)
        expect(response.body).to include(book.title)
      end
      it 'showアクションにリクエストするとレスポンスに登録済みの本の作者が存在する' do
        get book_path(book)
        expect(response.body).to include(book.author)
      end
      it 'showアクションにリクエストするとレスポンスに登録済みの本の説明が存在する' do
        get book_path(book)
        expect(response.body).to include(book.content)
      end
      it 'showアクションにリクエストするとレスポンスに登録済みの本のカテゴリーが存在する' do
        get book_path(book)
        expect(response.body).to include(book.category.name)
      end
    end
  end

  describe 'GET #edit' do
    context '管理者ユーザーでログインした場合' do
      before do
        sign_in(admin)
      end
      it 'editアクションにリクエストすると正常にレスポンスが返ってくる' do
        get edit_book_path(book)
        expect(response.status).to eq 200
      end
      it 'editアクションにリクエストするとレスポンスに本編集フォームが存在する' do
        get new_book_path(book)
        expect(response.body).to include('登録')
      end
    end
    context '一般ユーザーででログインした場合' do
      before do
        sign_in(user)
      end
      it 'editアクションにリクエストすると正常にレスポンスが返ってきていない' do
        get edit_book_path(book)
        expect(response.status).not_to eq 200
      end
      it 'トップページに遷移すること' do
        get edit_book_path(book)
        expect(response).to redirect_to root_path
      end
    end
    context 'ログアウト状態の場合' do
      it 'editアクションにリクエストすると正常にレスポンスが返ってきていない' do
        get edit_book_path(book)
        expect(response.status).not_to eq 200
      end
      it 'トップページに遷移すること' do
        get edit_book_path(book)
        expect(response).to redirect_to root_path
      end
    end
  end
end