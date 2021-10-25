require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:book) { FactoryBot.create(:book) }
  let(:comment_params) do
    { comment: { text: 'test', book_id: book.id } }
  end

  describe 'POST #create' do
    it 'createアクションにレスポンスすると正常にレスポンスが返ってきている' do
      post book_comments_path(book), params: comment_params
      expect(response.status).to eq 204
    end
    it 'データベースに保存ができている' do
      expect { post book_comments_path(book), params: comment_params }.to change(Comment, :count).by(1)
    end
  end
end
