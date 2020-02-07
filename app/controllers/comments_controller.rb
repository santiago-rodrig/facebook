class CommentsController < ApplicationController
  def comment_post
    @user = User.find(comment_params[:user_id])
    @post = Post.find(comment_params[:post_id])
    @user.comment(@post, comment_params[:body])

    redirect_to post_path(@post)
  end

  def comment_params
    params.require(:comment).permit(:body, :post_id, :user_id)
  end
end
