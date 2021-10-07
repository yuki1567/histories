class CartsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    cart = current_user.cart
    cart.quantity += params[:quantity].to_i
    book = Book.find(params[:book_id])
    book.quantity -= params[:quantity].to_i
    if cart.save 
      book.save
      CartBook.create(cart_book_params)
      redirect_to root_path
    else
      @book = Book.find(params[:book_id])
      render template: 'books/show'
    end
  end

  private

  def cart_book_params
    params.permit(:book_id).merge(cart_id: current_user.cart.id)
  end
end
