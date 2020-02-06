class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = current_user.feed.recents.paginate(page: params[:page], per_page: 10)

    if params[:page]
      @first_half = @posts.offset(10 * (params[:page].to_i - 1)).first(5)
      @second_half = @posts.offset(10 * (params[:page].to_i - 1) + 5).first(5)
    else
      @first_half = @posts.first(5)
      @second_half = @posts.offset(5).first(5)
    end

    @of_who = 'All'
  end

  def new
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.order('created_at DESC')
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = 'Post created'
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      flash[:success] = 'Post updated'
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])

    if @post.destroy
      flash[:success] = 'Post deleted'
      redirect_to root_path
    else
      flash[:danger] = 'Could not delete the post'
      redirect_to post_path(@post)
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
