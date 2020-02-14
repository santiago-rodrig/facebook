require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  before do
    @user = User.create(
      email: 'bob@example.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )

    @post = @user.posts.create(
      title: 'The great savannah',
      content: 'Is really great'
    )

    @other_user = User.create(
      email: 'jen@example.com',
      first_name: 'jen',
      last_name: 'mills',
      password: 'hidden',
      password_confirmation: 'hidden'
    )

    sign_in(@user)
  end

  describe '#like_post' do
    context 'the user owns the post' do
      before do
        post(
          :like_post,
          params: {
            post_id: @post.id
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

      it 'likes the post' do
        expect(@post.likers.include?(@user)).to be_truthy
        expect(@user.liked_posts.include?(@post)).to be_truthy
      end

      it 'does not like the post if the user already liked it' do
        like_count = @user.liked_posts.count

        post(
          :like_post,
          params: {
            post_id: @post.id
          }
        )

        expect(@user.liked_posts.count).to eq(like_count)
      end
    end

    context 'the user does not own the post' do
      before do
        sign_out(@user)
        sign_in(@other_user)

        post(
          :like_post,
          params: {
            post_id: @post.id
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

      it 'likes the post' do
        expect(@post.likers.include?(@other_user)).to be_truthy
        expect(@other_user.liked_posts.include?(@post)).to be_truthy
      end

      it 'does not like the post if the user already liked it' do
        like_count = @other_user.liked_posts.count

        post(
          :like_post,
          params: {
            post_id: @post.id
          }
        )

        expect(@other_user.liked_posts.count).to eq(like_count)
      end
    end
  end

  describe '#unlike_post' do
    context 'the user owns the post' do
      before do
        @user.like(@post)

        delete(
          :unlike_post,
          params: {
            post_id: @post.id
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

      it 'dislike the post' do
        expect(@user.liked_posts.include?(@post)).to be_falsy
        expect(@post.likers.include?(@user)).to be_falsy
      end

      it 'does not dislike the post if the user has not liked the post' do
        like_count = @user.liked_posts.count

        delete(
          :unlike_post,
          params: {
            post_id: @post.id
          }
        )

        expect(@user.liked_posts.count).to eq(like_count)
      end
    end

    context 'the user does not own the post' do
      before do
        sign_out(@user)
        sign_in(@other_user)
        @other_user.like(@post)

        delete(
          :unlike_post,
          params: {
            post_id: @post.id
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

      it 'dislike the post' do
        expect(@other_user.liked_posts.include?(@post)).to be_falsy
        expect(@post.likers.include?(@other_user)).to be_falsy
      end

      it 'does not dislike the post if the user has not liked the post' do
        like_count = @other_user.liked_posts.count

        delete(
          :unlike_post,
          params: {
            post_id: @post.id
          }
        )

        expect(@other_user.liked_posts.count).to eq(like_count)
      end
    end
  end
end
