class UsersController < ApplicationController
  before_action :user_admin, only: [:index]

  def index
    @users = User.all
  end
  
  def show
  end

  def user_admin
    redirect_to root_path unless user_signed_in? && current_user.admin?
  end
end
