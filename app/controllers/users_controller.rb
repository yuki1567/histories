class UsersController < ApplicationController
  before_action :user_admin, only: [:index]
  before_action :authenticate_user!, only: [:show]
  before_action :move_to_index, only: [:show]


  def index
    @users = User.all
  end
  
  def show
  end

  def user_admin
    redirect_to root_path unless user_signed_in? && current_user.admin?
  end

  def move_to_index
    @user = User.find(params[:id])
    redirect_to root_path unless current_user.admin? || @user.id == current_user.id
  end
end
