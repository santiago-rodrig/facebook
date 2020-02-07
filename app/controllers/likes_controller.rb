class LikesController < ApplicationController
  def like_post
    @post = Post.find(params[:post_id])
    @user = User.find(params[:user_id])

    @user.like(@post) unless @post.likers.include? @user

    redirect_to post_path(@post)
  end

  def unlike_post
    @post = Post.find(params[:post_id])
    @user = User.find(params[:user_id])

    @user.unlike(@post) if @post.likers.include? @user

    redirect_to post_path(@post)
  end
end
