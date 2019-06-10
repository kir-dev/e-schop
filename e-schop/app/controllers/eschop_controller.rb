class EschopController < ApplicationController
  skip_before_action :session_check

  def index
    unless session[:user_id].nil?
      redirect_to '/landing'
    end
  end
end
