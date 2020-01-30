require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test 'it creates a post' do
    assert_difference('Post.count') do
      post(
        posts_path,
        params: {
          post: {
            title: 'The test',
            content: 'Testing is important',
            author_id: @user.id
          }
        }
      )
    end
  end

  def setup
    post(
      user_registration_path,
      params: {
        user: {
          email: 'example@email.com',
          first_name: 'bob',
          last_name: 'sinclair',
          password: 'secret',
          password_confirmation: 'secret'
        }
      }
    )
    @user = User.last
    post(
      posts_path,
      params: {
        post: {
          title: 'The test',
          content: 'Testing is important',
          author_id: @user.id
        }
      }
    )
    @post = Post.last
  end

  test 'root should go to posts index' do
    get root_url
    assert_equal controller.controller_name, 'posts'
    assert_equal controller.action_name, 'index'
  end

  test '#index should set all @posts' do
    get root_url
    assert_equal Post.all, assigns(:posts)
  end

  test 'should GET #new' do
    get new_post_path
    assert_response(:success)
  end

  test '#new should set a @post' do
    get new_post_path
    assert assigns(:post)
  end

  test '#new should display a form' do
    get new_post_path
    assert_select 'form'
  end

  test '#new should display a text field for the title' do
    get new_post_path
    assert_select 'form input[type="text"]#post_title'
  end

  test '#new should display a textarea for the content' do
    get new_post_path
    assert_select 'form textarea#post_content'
  end

  test '#new should display a submit button' do
    get new_post_path
    assert_select 'form button[type="submit"]'
  end

  test 'should GET #show' do
    get post_path(@post)
    assert_response(:success)
  end

  test 'should GET #edit' do
    get edit_post_path(@post)
    assert_response(:success)
  end
end
