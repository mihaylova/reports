class Users::RegistrationsController < Devise::RegistrationsController
  before_action :set_user
  before_action :authenticate_user!
  
  def update
    if @user.update(user_params)
      set_flash_message :notice, :updated
      redirect_to account_path
    else
      render "edit", alert: "Your profile wasn't update"
    end
  end

  def update_password
    if set_new_password
      sign_in @user, :bypass => true
      redirect_to account_path
    else
      render "edit", alert: "Your password wasn't update"
    end
  end

private
    def user_params
      params.require(:user).permit(:email, :name, :image).merge!({last_editor_id: nil})
    end

    def user_password_params
      attributes = params.require(:user).permit(:password, :password_confirmation, :current_password)
      attributes.merge!({last_editor_id: nil})
      unless @user.has_password?
        attributes.delete :current_password
        attributes.store(:has_password, true)
      end 
      attributes
    end

    def set_user
      @user = current_user
    end

    def set_new_password
      if @user.has_password?
        @user.update_with_password(user_password_params)
      else
        @user.update(user_password_params)
      end
    end
end
