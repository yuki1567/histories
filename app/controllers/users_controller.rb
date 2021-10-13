class UsersController < ApplicationController
  before_action :admin_only, only: [:index]
  before_action :authenticate_user!, only: [:show, :edit]
  before_action :move_to_index, only: [:show, :edit]
  before_action :set_user, only: [:edit, :update]

  def index
    @users = User.all
  end

  def show
    @borrowing_book = @user.borrows.where(borrowing_book: 1)
    @borrow_books = BorrowBook.where(borrow_id: @borrowing_book)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :kana_name)
  end

  def admin_only
    redirect_to root_path unless user_signed_in? && current_user.admin?
  end

  def move_to_index
    @user = User.find(params[:id])
    redirect_to root_path unless current_user.admin? || @user.id == current_user.id
  end

  def set_user
    @user = User.find(params[:id])
  end
end
