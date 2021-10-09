class BorrowsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new]
  before_action :set_cart_books, only: [:new, :create]
  before_action :move_to_index, only: [:index]
  before_action :set_borrows, only: [:index, :update]

  def index
  end

  def new
    borrowing_book = current_user.borrows.where(borrowing_book: 1)
    if borrowing_book.present?
      flash.now[:danger] = "⚠️すでに本を借りています。再び借りるには本を返却してください。"
      render template: 'carts/show'
    else
      @borrow_address = BorrowAddress.new
    end
  end

  def create
    @borrow_address = BorrowAddress.new(borrow_params)
    if @borrow_address.valid?
      @cart_books.each do |cart_book, i|
        cart_book.book.increment!(:quantity, -1)
        current_user.cart.increment!(:quantity, -1)
        cart_book.destroy
      end
      @borrow_address.save
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    @borrows.update(borrowing_book: 0)
    @borrow_books = BorrowBook.where(borrow_id: @borrows)
    @borrow_books.each do |borrow_book|
      borrow_book.book.increment!(:quantity, 1)
    end
    redirect_to users_path
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

  def set_borrows
    @user = User.find(params[:user_id])
    @borrows = @user.borrows
  end

end
