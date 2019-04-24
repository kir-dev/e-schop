class EschopController < ApplicationController

    def index
        if session[:user_id] != nil
            redirect_to '/landing'
        end
    end

    def list
        @goods = Good.all
    end
end
