class HomeController < ApplicationController
  def index
    render 'layouts/application', layout: false
  end
end
