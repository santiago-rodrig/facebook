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
      post(like_post_user_path(id: @user.id, post_id: @post.id))
    end
  end
end
