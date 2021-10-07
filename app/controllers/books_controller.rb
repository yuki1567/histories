class BooksController < ApplicationController
  before_action :user_admin, only: [:new, :edit]
  before_action :set_book, only: [:show, :edit, :update]

  def index
    @books = Book.all.order('created_at DESC')
  end

  def show
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

  private

  def book_params
    params.require(:book).permit(:image, :title, :author, :content, :quantity, :category_id)
  end

  def user_admin
    redirect_to root_path unless user_signed_in? && current_user.admin?
  end

  def set_book
    @book = Book.find(params[:id])
  end
end
