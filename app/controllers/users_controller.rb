class UsersController < ApplicationController

  def edit
    @user = current_user
  end


  def update
    @user = current_user.update(user_params)
    redirect_to edit_account_path
  end

  def user_params
    params.require(:user).permit(:name, :image)
  end
end
