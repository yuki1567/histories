class BooksController < ApplicationController
  before_action :admin_only, only: [:new, :edit, :destroy]
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @books = Book.all.order('created_at DESC')
  end

  def show
    @comment = Comment.new
    @comments = @book.comments.includes(:book)
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    cart_books = @book.cart_books
    if cart_books.present?
      cart_id = cart_books.select(:cart_id)
      cart = Cart.find_by(id: cart_id)
      cart.increment!(:quantity, -1)
    end
    @book.destroy
    redirect_to root_path
  end

  def search
    @books = @search.result
    if params[:q][:category_id_eq]
      @category = Category.find(params[:q][:category_id_eq])
    end
  end

  private

  def book_params
    params.require(:book).permit(:image, :title, :author, :content, :quantity, :category_id)
  end

  def admin_only
    redirect_to root_path unless user_signed_in? && current_user.admin?
  end

  def set_book
    @book = Book.find(params[:id])
  end
end
