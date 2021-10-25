require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { FactoryBot.build(:comment) }

  describe 'コメント' do
    it 'bookが紐付いていればコメントできる' do
      expect(comment).to be_valid
    end
    it 'bookが紐付いていないとコメントできない' do
      comment.book = nil
      comment.valid?
      expect(comment.errors).to be_added(:book, :blank)
    end
  end
end
