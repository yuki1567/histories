class BorrowsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new]
  before_action :set_cart_books, only: [:new, :create]
  before_action :move_to_index, only: [:index]

  def index
    @borrows = @user.borrows
  end

  def new
    @borrow_address = BorrowAddress.new
  end

  def create
    @borrow_address = BorrowAddress.new(borrow_params)
    if @borrow_address.valid?
      @cart_books.each do |cart_book, i|
        cart_book.book.increment!(:quantity, 1)
        current_user.cart.increment!(:quantity, 1)
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

  def move_to_index
    @user = User.find(params[:user_id])
    redirect_to root_path unless current_user.admin? || @user.id == current_user.id
  end
end
