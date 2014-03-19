class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  layout false
  before_action :parse_facebook_cookies, only: :facebook_login

  def parse_facebook_cookies
    @facebook_cookies = Koala::Facebook::OAuth.new(ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']).get_user_info_from_cookie(cookies)
  end

  # def facebook
  #   @user = User.find_for_facebook_oauth(request.env["omniauth.auth"])

  #   if @user.persisted?
  #     sign_in @user, :event => :authentication #this will throw if @user is not activated
  #     set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  #     @redirect_to = root_url
  #   else
  #     session["devise.facebook_data"] = request.env["omniauth.auth"]
  #     @redirect_to = new_user_registration_url
  #   end
  # end

  def facebook_login
    access_token = @facebook_cookies["access_token"]
    graph = Koala::Facebook::GraphAPI.new(access_token)
    user_data = graph.get_object("me")
    
    user = User.find_for_facebook_oauth(user_data, access_token)

    if user.persisted?
      user.update(access_token: access_token)
      sign_in(:user, user)
      render nothing: true
    else
      @redirect_to = new_user_registration_url
    end
  end
end