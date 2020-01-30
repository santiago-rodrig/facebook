class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.all
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def post_params
  end
end
