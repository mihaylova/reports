class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_user

  def show
  end


  private
    def set_user
      @user = current_user
    end
end
