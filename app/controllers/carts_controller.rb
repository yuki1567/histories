class CartsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :create]
  before_action :set_cart, only: [:show, :destroy]

  def show
    @cart_books = @cart.cart_books.includes(:cart)
  end

  def create
    book = Book.find(params[:book_id])
    unless current_user.cart.cart_books.where(book_id: book.id).present?
      cart = current_user.cart
      cart.quantity += params[:quantity].to_i
      if cart.save
        CartBook.create(cart_book_params)
        redirect_to root_path
      else
        @book = Book.find(params[:book_id])
        render template: 'books/show' and return
      end
    else
      @book = Book.find(params[:book_id])
      flash.now[:danger] = "すでに同じ本がカートの中に入っています"
      render template: 'books/show'
    end
  end

  def destroy
    cart_book = @cart.cart_books.find_by(book_id: params[:book_id])
    cart_book.destroy
    @cart.increment!(:quantity, -1)
    redirect_to user_cart_path(current_user, @cart)
  end

  private

  def cart_book_params
    params.permit(:book_id).merge(cart_id: current_user.cart.id)
  end

  def set_cart
    @cart = Cart.find(params[:id])
  end
end
