class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  layout false
  before_action :check_email_for_current_user

  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"])

    if @user.persisted?
      @redirect_to = current_user ? account_url : root_url
      sign_in @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      @redirect_to = new_user_registration_url
    end
  end

  private
    def check_email_for_current_user
      redirect_to account_path, alert: "The emails must be the same" if current_user && current_user.email != request.env["omniauth.auth"].info.email
    end
end