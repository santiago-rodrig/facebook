require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  before do
    @user = User.create(
      email: 'bob@example.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )

    @post = @user.posts.create(
      title: 'The giant sea',
      content: 'Is all blue'
    )

    @other_user = User.create(
      email: 'jean@example.net',
      first_name: 'jean',
      last_name: 'squarepants',
      password: 'hidden',
      password_confirmation: 'hidden'
    )

    sign_in(@user)
  end

  describe '#comment_post' do
    before do
      post(
        :comment_post,
        params: {
          comment: {
            post_id: @post.id,
            body: 'This post is amazing'
          }
        }
      )
    end

    it 'redirects' do
      expect(response).to have_http_status(:redirect)
    end

    it 'redirects to posts#show' do
      expect(response).to redirect_to(post_path(@post))
    end

    it 'sets @post' do
      expect(assigns(:post)).to eq(@post)
    end

    context 'the user owns the post' do
      it 'comments the post' do
        expect(@post.commenters.include?(@user)).to be_truthy
        expect(@user.commented_posts.include?(@post)).to be_truthy
      end
    end

    context' the user does not own the post' do
      before do
        sign_out(@user)
        sign_in(@other_user)
      end

      it 'comments the post' do
        expect(@post.commenters.include?(@user)).to be_truthy
        expect(@user.commented_posts.include?(@post)).to be_truthy
      end
    end
  end
end
