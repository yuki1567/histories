require 'rails_helper'

RSpec.describe 'コメント', type: :system do
  let(:cart) { FactoryBot.create(:cart) }
  let(:user) { cart.user }
  let(:book) { FactoryBot.create(:book) }
  let(:comment) { FactoryBot.build(:comment, book_id: book.id) }

  context 'コメントができる場合' do
    it 'ログイン状態ならコメントができる' do
      # ログインする
      sign_in(user)
      # 本情報詳細ページに移動する
      visit book_path(book)
      # コメントを入力する
      fill_in 'comment_text', with: comment.text
      # コメントボタンを押すとCommentモデルのカウントが１上がることを確認する
      expect {
        find_button("コメントする").click
      }.to change { Comment.count }.by(1)
      # コメントが表示されていることを確認する
      expect(page).to have_content(comment.text)
    end
  end
  context 'コメントができない場合' do
    it 'ログアウト状態ではコメントができない' do
      # 本情報詳細ページに移動する
      visit book_path(book)
      # コメントフォームがないことを確認する
      expect(page).to have_no_content("コメントする")
    end
  end
end