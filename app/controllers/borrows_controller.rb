class BorrowsController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  before_action :set_cart_books, only: [:new, :create]

  def new
    @borrow_address = BorrowAddress.new
  end

  def create
    @borrow_address = BorrowAddress.new(borrow_params)
    if @borrow_address.valid?
      @cart_books.each do |cart_book, i|
        cart_book.book.quantity -= 1
        current_user.cart.quantity -= 1
        cart_book.book.save
        current_user.cart.save
        cart_book.destroy
      end
      @borrow_address.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def borrow_params
    params.require(:borrow_address).permit(:postal_code, :prefecture_id, :city, :street_address, :detail_address, :phone_number, book_ids: []).merge(user_id: current_user.id)
  end

  def set_cart_books
    @cart_books = current_user.cart.cart_books.includes(:cart)
  end
end
