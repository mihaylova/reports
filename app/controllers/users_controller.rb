class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_user

  def show
  end

  def remove_fb_account
    if @user.has_password?
      @user.update({provider: nil, uid: nil})
      redirect_to account_path
    else
      redirect_to edit_user_registration_path, alert: "Your facebook account wasn't removed"
    end
  end


  private
    def set_user
      @user = current_user
    end
end
