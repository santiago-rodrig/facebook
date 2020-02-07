require 'test_helper'

class PostsLikesTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(
      email: 'example@host.net',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )

    Post.delete_all
    @post = @user.posts.create(
      title: 'The test',
      content: 'Testing is fun'
    )

    post(
      user_session_path,
      params: {
        user: {
          email: @user.email,
          password: 'secret'
        }
      }
    )
  end

  test 'user can like a post' do
    assert_difference('@post.likers.count') do
      post(like_post_path(user_id: @user.id, post_id: @post.id))
    end
  end

  test 'user can like a post only if he haven\'t liked the post yet' do
    post(like_post_path(user_id: @user.id, post_id: @post.id))

    assert_no_difference('@post.likers.count') do
      post(like_post_path(user_id: @user.id, post_id: @post.id))
    end
  end

  test 'like link is disabled if the user already liked the post' do
    post(like_post_path(user_id: @user.id, post_id: @post.id))
    get post_path(@post)
    assert_select 'a[href=?][disabled="disabled"]', like_post_path(user_id: @user.id, post_id: @post.id)
  end

  test 'user can unlike a post' do
    post(like_post_path(user_id: @user.id, post_id: @post.id))

    get post_path(@post)
    assert_select 'a[href=?]', unlike_post_path(user_id: @user.id, post_id: @post.id)

    assert_difference('@post.likers.count', -1) do
      delete(unlike_post_path(user_id: @user.id, post_id: @post.id))
    end
  end

  test 'user can\'t unlike a post if he haven\'t liked it yet' do
    get post_path(@post)
    assert_select 'a[href=?][disabled="disabled"]', unlike_post_path(user_id: @user.id, post_id: @post.id)

    assert_no_difference('@post.likers.count') do
      delete(unlike_post_path(user_id: @user.id, post_id: @post.id))
    end
  end
end
