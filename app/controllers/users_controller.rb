class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_user

  after_action :update_notifications_state, only: :notifications

  def show
  end

  def remove_fb_account
    if @user.has_password?
      @user.update({provider: nil, uid: nil, last_editor_id: nil})
      redirect_to account_path
    else
      redirect_to edit_user_registration_path, alert: "Your facebook account wasn't removed"
    end
  end

  def notifications
    @notifications = @user.notifications.to_a.dup
    # @notifications.freeze
    print "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAin action"
    print @notifications
  end


  private
    def update_notifications_state
      @user.notifications.update_all(is_new: false)
      print "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
      print @user.notifications.to_a
    end

    def set_user
      @user = current_user
    end
end
