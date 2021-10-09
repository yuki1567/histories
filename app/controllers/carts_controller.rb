class CartsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :create]
  before_action :set_cart, only: [:show, :destroy]

  def show
    @cart_books = @cart.cart_books.includes(:cart).order('created_at DESC')
  end

  def create
    cart = current_user.cart
    cart.quantity += params[:quantity].to_i
    if cart.save
      CartBook.create(cart_book_params)
      redirect_to root_path
    else
      @book = Book.find(params[:book_id])
      render template: 'books/show'
    end
  end

  def destroy
    cart_book = @cart.cart_books.find_by(book_id: params[:book_id])
    cart_book.destroy
    @cart.quantity -= 1
    @cart.save
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