class CommentsController < ApplicationController
  def comment_post
    @post = Post.find(comment_params[:post_id])
    current_user.comment(@post, comment_params[:body])

    redirect_to post_path(@post)
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :post_id)
  end
end
