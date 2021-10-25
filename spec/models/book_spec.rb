require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) { FactoryBot.build(:book) }

  describe '本の登録' do
    context '本の登録ができる場合' do
      it 'image, title, author, content, quantity, category_idが存在すれば登録できる' do
        expect(book).to be_valid
      end
      it 'quantityが半角数字であれば登録できる' do
        book.quantity = 10
        expect(book).to be_valid
      end
    end
    context '本の登録ができない場合' do
      it 'imageが空では登録できない' do
        book.image = nil
        book.valid?
        expect(book.errors).to be_added(:image, :blank)
      end
      it 'titleが空では登録できない' do
        book.title = ''
        book.valid?
        expect(book.errors).to be_added(:title, :blank)
      end
      it 'authorが空では登録できない' do
        book.author = ''
        book.valid?
        expect(book.errors).to be_added(:author, :blank)
      end
      it 'contentが空では登録できない' do
        book.content = ''
        book.valid?
        expect(book.errors).to be_added(:content, :blank)
      end
      it 'quantityが空では登録できない' do
        book.quantity = ''
        book.valid?
        expect(book.errors).to be_added(:quantity, :blank)
      end
      it 'quantityが半角数字以外では登録できない' do
        book.quantity = 'a'
        book.valid?
        expect(book.errors).to be_of_kind(:quantity, :not_a_number)
      end
      it 'category_idが空では登録できない' do
        book.category_id = ''
        book.valid?
        expect(book.errors).to be_added(:category_id, :blank)
      end
    end
  end
end
