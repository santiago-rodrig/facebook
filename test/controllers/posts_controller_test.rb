require 'test_helper'

# rubocop:disable Metrics/ClassLength
class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    Post.delete_all
    @user = User.create(
      email: 'example@email.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )
    @post = @user.posts.create(title: 'The test', content: 'Testing is important')
    post(
      user_session_path,
      params: {
        user: {
          email: 'example@email.com',
          password: 'secret'
        }
      }
    )
  end

  test 'it creates a post' do
    assert_difference('Post.count') do
      post(
        posts_path,
        params: {
          post: {
            title: 'The test',
            content: 'Testing is important'
          }
        }
      )
    end
  end

  test 'root should go to posts#index' do
    get root_url
    assert_equal controller.controller_name, 'posts'
    assert_equal controller.action_name, 'index'
  end

  test '#index should set first_half' do
    get root_url
    assert_not_nil assigns(:first_half)
  end

  test '#index should set second_half' do
    get root_url
    assert_not_nil assigns(:second_half)
  end

  test '#index should display All Posts as a heading' do
    get root_url
    assert_select 'h1', text: 'All Posts'
  end

  test '#index should list all @posts' do
    get root_url

    assigns(:first_half).each do |p|
      assert_select 'div.well', match: /.*#{p.title}.*#{p.content[0...300]}.*/mi
    end

    assigns(:second_half).each do |p|
      assert_select 'div.well', match: /.*#{p.title}.*#{p.content[0...300]}.*/mi
    end
  end

  test '#index should list all @posts with author image linked to its profile' do
    get root_url

    assigns(:first_half).each do |p|
      assert_select 'div.well a[href=?] > img[src=?]', user_path(p.author), p.author.image_url + '?s=50'
    end

    assigns(:second_half).each do |p|
      assert_select 'div.well a[href=?] > img[src=?]', user_path(p.author), p.author.image_url + '?s=50'
    end
  end

  test '#index should list all @posts with #show link' do
    get root_url

    assigns(:first_half).each do |p|
      assert_select 'div.well a[href=?] h3', post_path(p)
    end

    assigns(:second_half).each do |p|
      assert_select 'div.well a[href=?] h3', post_path(p)
    end
  end

  test '#index should show the number of likes' do
    get root_url

    assigns(:first_half).each do |p|
      assert_select 'div.well span.glyphicon.glyphicon-thumbs-up'
      assert_select 'div.well span.badge', text: p.likers.count.to_s
    end

    assigns(:second_half).each do |p|
      assert_select 'div.well span.glyphicon.glyphicon-thumbs-up'
      assert_select 'div.well span.badge', text: p.likers.count.to_s
    end
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

  test '#show should display the title of the post' do
    get post_path(@post)
    assert_select 'h1', text: @post.title
  end

  test '#show should display the name of the author and write time' do
    get post_path(@post)
    assert_select 'p', match: /.*#{@post.author.full_name}.*#{@post.created_at.to_time.utc}.*/mi
  end

  test '#show should display the content of the post' do
    get post_path(@post)
    assert_select 'p', text: @post.content
  end

  test '#show displays the image of the author linked to the profile' do
    get post_path(@post)
    assert_select 'a[href=?] > img[src=?]', user_path(@post.author), @post.author.image_url
  end

  test '#show displays a edit link if the current user is the author' do
    get post_path(@post)
    assert_select 'a[href=?]', edit_post_path(@post)
    @other = User.create(
      email: 'john@doe.ar',
      first_name: 'John',
      last_name: 'Doe',
      password: 'secret',
      password_confirmation: 'secret'
    )
    @post2 = @other.posts.create(title: 'Gaussian bell', content: 'Hipopotamus')
    get post_path(@post2)
    assert_select 'a[href=?]', edit_post_path(@post), 0
  end

  test '#show displays a delete link if the current user is the author' do
    get post_path(@post)
    assert_select 'a[href=?]', post_path(@post), text: 'Delete'
    @other = User.create(
      email: 'john@doe.ar',
      first_name: 'John',
      last_name: 'Doe',
      password: 'secret',
      password_confirmation: 'secret'
    )
    @post2 = @other.posts.create(title: 'Gaussian bell', content: 'Hipopotamus')
    get post_path(@post2)
    assert_select 'a[href=?]', post_path(@post), 0, text: 'Delete'
  end

  test '#show displays link to like post' do
    get post_path(@post)
    assert_select 'a[href=?]', like_post_user_path(id: @user.id, post_id: @post.id)
  end

  test '#show displays likes count' do
    get post_path(@post)
    assert_select 'span.glyphicon.glyphicon-thumbs-up'
    assert_select 'span.badge', text: @post.likers.count.to_s
  end

  test 'should GET #edit' do
    get edit_post_path(@post)
    assert_response(:success)
  end

  test '#edit sets the @post' do
    get edit_post_path(@post)
    assert_equal assigns(:post), @post
  end

  test '#edit displays a form' do
    get edit_post_path(@post)
    assert_select 'form'
  end

  test '#edit displays a text field for the title' do
    get edit_post_path(@post)
    assert_select 'form input[type="text"]#post_title'
  end

  test '#edit displays a textarea for the content' do
    get edit_post_path(@post)
    assert_select 'form textarea#post_content'
  end

  test '#edit displays a submit button' do
    get edit_post_path(@post)
    assert_select 'form button[type="submit"]'
  end

  test 'should #update a post' do
    put(
      post_path(@post),
      params: {
        id: @post.id,
        post: {
          title: 'Other title'
        }
      }
    )
    assert_not_equal assigns(:post).title, @post.title
  end

  test 'should #destroy a user' do
    assert_difference('Post.count', -1) do
      delete(post_path(@post))
    end
  end

  test '#destroy should redirect to root_path' do
    delete(post_path(@post))
    assert_redirected_to root_path
  end
end
# rubocop:enable Metrics/ClassLength
