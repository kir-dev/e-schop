class UsersController < ApplicationController
  skip_before_action :session_check, only: [:login, :new, :create, :create_params]
  before_action :check_good_id, only: [:good_show]
  def login
    @user = User.new
  end

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(username: params[:user][:username], roomnumber: params[:user][:roomnumber])
    if @user.nil?
      @user = User.new(create_params)
      @user.save
      redirect_to '/', notice: t(:user_create)
    else
      redirect_to '/new', notice: t(:user_exists)
    end
  end

  def show
    @purchases = Purchase.all
    @goods = Good.all
  end

  def good_show
    @good = Good.with_deleted.find(params[:id])
  end

  def edit; end

  def update
    if current_user.update_attributes(edit_params)
      redirect_to action: 'show'
    else
      render action: 'edit'
    end
  end

  def pass_edit
    @user = User.new
  end

  def pass_update
    error = false
    if current_user.authenticate(pass_check[:password_check])
      if current_user.update_attributes(pass_edit_params)
      else
        error = true
      end
    else
      error = true
    end

    if error == false
      redirect_to action: 'show'
    else
      render action: 'pass_edit'
    end
  end

  def my_cart
    @purchases = Purchase.all
  end

  def my_goods
    @goods = Good.without_deleted.all
  end

  def sold_goods
    @purchases = Purchase.all
  end

  def show_other_user
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

  def pass_check
    params.require(:user).permit(:password_check)
  end
end
