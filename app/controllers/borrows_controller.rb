class BorrowsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new]
  before_action :set_user, only: [:index, :new, :create, :update]
  before_action :set_cart_books, only: [:new, :create]
  before_action :set_borrowing_book, only: [:new, :update]

  def index
    redirect_to root_path unless current_user.admin? || @user.id == current_user.id
    @borrow_books = BorrowBook.where(borrow_id: @user.borrows).order('created_at DESC')
  end

  def new
    if @borrowing_book.present?
      flash[:danger] = '⚠️すでに本を借りています。再び借りるには本を返却してください。'
      redirect_to user_cart_path(@user, @user.cart)
    else
      @borrow_address = BorrowAddress.new
    end
  end

  def create
    @borrow_address = BorrowAddress.new(borrow_params)
    if @borrow_address.valid?
      @cart_books.each do |cart_book|
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
    borrow_books = BorrowBook.where(borrow_id: @borrowing_book)
    borrow_books.each do |borrow_book|
      borrow_book.book.increment!(:quantity, 1)
    end
    @borrowing_book.update(borrowing_book: 0)
    redirect_to users_path
  end

  private

  def borrow_params
    params.require(:borrow_address).permit(:postal_code, :prefecture_id, :city, :street_address, :detail_address, :phone_number,
                                           book_ids: []).merge(user_id: current_user.id)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_cart_books
    @cart_books = @user.cart.cart_books.includes(:cart)
  end

  def set_borrowing_book
    @borrowing_book = @user.borrows.where(borrowing_book: 1)
  end
end
