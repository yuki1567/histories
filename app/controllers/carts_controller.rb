class CartsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :create, :destroy]
  before_action :set_cart_books, only: [:show, :create, :destroy]
  before_action :move_to_index, only: [:show, :destroy]

  def show
  end

  def create
    book = Book.find(params[:book_id])
    if @cart_books.where(book_id: book.id).present?
      @book = Book.find(params[:book_id])
      @comments = @book.comments.includes(:book)
      flash.now[:danger] = '⚠️同じ本がすでにカートの中にあります'
      render template: 'books/show'
    else
      @cart.quantity += params[:quantity].to_i
      if @cart.save
        CartBook.create(cart_book_params)
        redirect_to root_path
      else
        @book = Book.find(params[:book_id])
        @comments = @book.comments.includes(:book)
        render template: 'books/show' and return
      end
    end
  end

  def destroy
    cart_book = @cart_books.find_by(book_id: params[:book_id])
    cart_book.destroy
    @cart.increment!(:quantity, -1)
    redirect_to user_cart_path(current_user, @cart)
  end

  private

  def cart_book_params
    params.permit(:book_id).merge(cart_id: current_user.cart.id)
  end

  def set_cart_books
    @cart = current_user.cart
    @cart_books = @cart.cart_books.includes(:cart).order('created_at DESC')
  end

  def move_to_index
    @user = User.find(params[:user_id])
    redirect_to root_path unless @user.id == current_user.id && @cart.id == current_user.cart.id
  end
end
