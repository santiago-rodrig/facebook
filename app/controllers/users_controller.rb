class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @title = 'All users'
    @users = User.paginate(page: params[:page], per_page: 12)
    @partial = 'user'

    if params[:page]
      @first_half = @users.offset(12 * (params[:page].to_i - 1)).first(6)
      @second_half = @users.offset(12 * (params[:page].to_i - 1) + 5).first(6)
    else
      @first_half = @users.first(6)
      @second_half = @users.offset(6).first(6)
    end

    render template: 'shared/index'
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.recents.paginate(page: params[:page], per_page: 10)

    if params[:page]
      @first_half = @posts.offset(10 * (params[:page].to_i - 1)).first(5)
      @second_half = @posts.offset(10 * (params[:page].to_i - 1) + 5).first(5)
    else
      @first_half = @posts.first(5)
      @second_half = @posts.offset(5).first(5)
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'User updated'
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :gender, :phone, :birthday)
  end
end
