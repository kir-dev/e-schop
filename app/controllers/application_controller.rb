class ApplicationController < ActionController::Base
    before_action :session_check
    def session_check
        if session[:user_id] == nil
            redirect_to :action => 'index', :controller =>'eschop'
        end
    end
    def check_good_id
        if Good.find_by_id(params[:id]) == nil
            redirect_to :action => 'landing', :controller => 'goods'
        end
    end
end
