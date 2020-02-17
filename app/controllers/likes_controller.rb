class LikesController < ApplicationController
  def like_post
    @post = Post.find(params[:post_id])
    current_user.like(@post) unless @post.likers.include? current_user

    redirect_to post_path(@post)
  end

  def unlike_post
    @post = Post.find(params[:post_id])
    current_user.unlike(@post) if @post.likers.include? current_user

    redirect_to post_path(@post)
  end
end
