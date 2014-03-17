class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_user

  def edit
  end

  def show
  end


  def update
    @user.update(user_params)
    render :show
  end

  private
    def user_params
      params.require(:user).permit(:name, :image)
    end

    def set_user
      @user = current_user
    end
end
