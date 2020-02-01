class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def user_posts
    @user = User.find(params[:id])
    @posts = @user.posts.order('created_at DESC')
    @of_who = current_user == @user ? 'Your' : @user.full_name

    render template: 'posts/index'
  end

  def like_post
    @post = Post.find(params[:post_id])
    @user = User.find(params[:id])
    @user.like(@post)

    redirect_back(fallback_location: root_path)
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :gender, :phone, :birthday)
  end
end
