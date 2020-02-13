require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  before do
    @bob = User.create(
      email: 'bob@example.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )

    sign_in(@bob)
  end

  describe '#index' do
    before do
      @posts = @bob.
        feed.
        recents.
        paginate(page: @controller.params[:page], per_page: 10)

      @first_half = @posts.first(5)
      @second_half = @posts.offset(5).first(5)
      @combined = @first_half + @second_half
      @title = 'Your feed'
      get :index
    end

    it 'GETs' do
      expect(response).to have_http_status(:success)
    end

    it 'sets @posts' do
      expect(assigns(:posts)).to eq(@posts)
    end

    it 'sets @first_half' do
      expect(assigns(:first_half)).to eq(@first_half)
    end

    it 'sets @second_half' do
      expect(assigns(:second_half)).to eq(@second_half)
    end

    it 'sets @title' do
      expect(assigns(:title)).to eq(@title)
    end
  end

  describe '#new' do
    before do
      get :new
    end

    it 'GETs' do
      expect(response).to have_http_status(:success)
    end

    it 'sets @post as a new Post' do
      expect(assigns(:post)).to be_a_new(Post)
    end
  end

  describe '#show' do
    before do
      @post = @bob.posts.create(
        title: 'Bob wrote this',
        content: 'Whatever'
      )

      get :show, params: { id: @post.id }
    end

    it 'GETs' do
      expect(response).to have_http_status(:success)
    end

    it 'sets @post' do
      expect(assigns(:post)).to eq(@post)
    end

    it 'sets @comments' do
      expect(assigns(:comments)).to eq(@post.comments.order('created_at DESC'))
    end
  end

  describe '#edit' do
    before do
      @post = @bob.posts.create(
        title: 'Bob wrote this',
        content: 'Whatever'
      )

      get :edit, params: { id: @post.id }
    end

    it 'GETs' do
      expect(response).to have_http_status(:success)
    end

    it 'sets @post' do
      expect(assigns(:post)).to eq(@post)
    end
  end

  describe '#update' do
    before do
      @post = @bob.posts.create(
        title: 'Bob wrote this',
        content: 'Whatever'
      )

      patch :update, params: { id: @post.id, post: { title: 'Bob is cool' } }
    end

    it 'redirects' do
      expect(response).to have_http_status(:redirect)
    end

    it 'redirects to #show' do
      expect(response).to redirect_to(post_path(@post))
    end

    it 'sets @post' do
      expect(assigns(:post)).to eq(@post)
    end

    it 'changes the data' do
      expect(assigns(:post).title).to eq('Bob is cool')
    end

    it 'sets flash[:success]' do
      expect(@controller.flash[:success]).to eq('Post updated')
    end
  end

  describe '#destroy' do
    before do
      @post = @bob.posts.create(
        title: 'Bob wrote this',
        content: 'Whatever'
      )

      @id = @post.id
      @count = Post.count
      delete :destroy, params: { id: @post.id }
    end

    it 'redirects' do
      expect(response).to have_http_status(:redirect)
    end

    it 'redirects to root' do
      expect(response).to redirect_to(root_path)
    end

    it 'sets @post' do
      expect(assigns(:post)).to eq(@post)
    end

    it 'deletes the post' do
      expect(Post.count).to eq(@count - 1)
      expect(Post.find_by(id: @id)).to be_nil
    end

    it 'sets flash[:success]' do
      expect(@controller.flash[:success]).to eq('Post deleted')
    end
  end

  describe '#create' do
    before do
      post(
        :create,
        params: {
          post: {
            title: 'Bob wrote this',
            content: 'Whatever'
          }
        }
      )

      @post = Post.new(title: 'Bob wrote this', content: 'Whatever')
    end

    it 'redirects' do
      expect(response).to have_http_status(:redirect)
    end

    it 'redirect to #show' do
      expect(response).to redirect_to(post_path(assigns(:post)))
    end

    it 'sets @post as a new post' do
      expect(assigns(:post)).not_to be_nil
    end

    it 'sets flash[:success]' do
      expect(@controller.flash[:success]).to eq('Post created')
    end

    it 'sets @post attributes' do
      expect(assigns(:post).title).to eq(@post.title)
      expect(assigns(:post).content).to eq(@post.content)
    end
  end
end
