class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.paginate(page: params[:page], per_page: 12)

    if params[:page]
      @first_half = @users.offset(12 * (params[:page].to_i - 1)).first(6)
      @second_half = @users.offset(12 * (params[:page].to_i - 1) + 5).first(6)
    else
      @first_half = @users.first(6)
      @second_half = @users.offset(6).first(6)
    end
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
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def like_post
    @post = Post.find(params[:post_id])
    @user = User.find(params[:id])

    @user.like(@post) unless @post.likers.include? @user

    redirect_back(fallback_location: root_path)
  end

  def unlike_post
    @post = Post.find(params[:post_id])
    @user = User.find(params[:id])

    @user.unlike(@post) if @post.likers.include? @user

    redirect_back(fallback_location: root_path)
  end

  def comment_post
    @user = User.find(comment_params[:user_id])
    @post = Post.find(comment_params[:post_id])
    @user.comment(@post, comment_params[:body])

    redirect_to post_path(@post)
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :gender, :phone, :birthday)
  end

  def comment_params
    params.require(:comment).permit(:body, :post_id, :user_id)
  end
end
