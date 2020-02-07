require 'test_helper'

class UserCommentPostTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(
      email: 'example@email.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )

    @post = @user.posts.create(
      title: 'Testing for begginers',
      content: 'Testing is an art'
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

  # rubocop:disable Metrics/BlockLength
  test 'user can comment on post' do
    get post_path(@post)
    assert_select 'form'
    assert_select 'form textarea#comment_body'
    assert_select 'form button[type="submit"]'

    assert_difference('@post.commenters.count') do
      post(
        comment_post_path,
        params: {
          comment: {
            user_id: @user.id,
            post_id: @post.id,
            body: 'Testing is amazing!'
          }
        }
      )
    end

    post(
      comment_post_path,
      params: {
        comment: {
          user_id: @user.id,
          post_id: @post.id,
          body: 'Testing is amazing!'
        }
      }
    )

    assert_redirected_to post_path(@post)
    follow_redirect!
    assert_equal @post.comments.order('created_at DESC'), assigns(:comments)
    assert_select 'div.panel-default div.panel-heading a[href=?]', user_path(@user)
    assert_select 'div.panel-default div.panel-heading', match: /#{@user.full_name}.*on.*#{Time.now.utc}/mi
    assert_select 'div.panel-default div.panel-body', text: Comment.last.body
  end
  # rubocop:enable Metrics/BlockLength
end
