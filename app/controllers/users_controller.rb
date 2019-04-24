class UsersController < ApplicationController
    def login
        @user = User.new
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(create_params)
        @users = User.all
        @error = false

        @users.each do |u|
            if u.username === @user.username && u.roomnumber === @user.roomnumber
                @error = true
            end
        end
        if @error == false && @user.save
            redirect_to '/'
        else 
            render action: "new"
        end
    end

    def show
        @user = User.find_by_id(session[:user_id])
        @goods = Good.all
    end

    def good_show
        @good = Good.find(params[:id])
    end

    def edit
        @user = User.find_by_id(session[:user_id])
    end

    def update
        @user = User.find_by_id(session[:user_id])

        if @user.update_attributes(edit_params)
            redirect_to action: "show"
        else
            render action: "edit"
        end
    end
    
    def pass_edit
        @user = User.new
    end

    def pass_update
        @user = User.find_by_id(session[:user_id])
        if @user.update_attributes(pass_edit_params)
            redirect_to action: "show"
        else 
            render action: "pass_edit"
        end
    end

    def my_cart
        @goods = Good.all
    end

    def my_goods
        @goods = Good.all
    end

    def show_buyer
        @user = User.find(params[:id])
    end

    private
        def create_params
            params.require(:user).permit(:username, :roomnumber, :password, :password_confirmation)
        end

        def edit_params
            params.require(:user).permit(:username, :roomnumber)
        end

        def pass_edit_params
            params.require(:user).permit(:password, :password_confirmation)
        end
end
