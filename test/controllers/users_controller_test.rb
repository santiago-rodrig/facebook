require 'test_helper'

# rubocop:disable Metrics/ClassLength
class UsersControllerTest < ActionDispatch::IntegrationTest
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
    @other = User.create(
      email: 'other@hidden.org',
      first_name: 'stacy',
      last_name: 'jones',
      password: 'secret',
      password_confirmation: 'secret'
    )
  end

  test 'should get #show' do
    get user_path(@user)
    assert_response(:success)
  end

  test '#show should assign the @user' do
    get user_path(@user)
    assert_equal @user, assigns(:user)
  end

  test '#show should display Your Profile as a heading if current user is the same' do
    get user_path(@user)
    assert_select 'h1', text: 'Your Profile'
  end

  test '#show should display full name Profile as a heading if current user is not the same' do
    get user_path(@other)
    assert_select 'h1', text: @other.full_name + ' ' + 'Profile'
  end

  test '#show should display a user info list' do
    get user_path(@user)
    assert_select 'dl.user-info'
  end

  test '#show should display the user phone in the info list' do
    get user_path(@user)
    assert_select 'dl.user-info dd', text: @user.phone
  end

  test '#show should display the user email in a paragraph' do
    get user_path(@user)
    assert_select 'dt', text: 'Email'
    assert_select 'dd', match: /#{@user.email}/
  end

  test '#show should display a link to edit the registration info if current user is the same' do
    get user_path(@user)
    assert_select 'a[href=?]', edit_user_registration_path(@user)
    delete(destroy_user_session_path)
    post(user_session_path, params: { user: { email: 'other@hidden.org', password: 'secret' } })
    get user_path(@user)
    assert_select 'a[href=?]', edit_user_registration_path(@user), 0
  end

  test '#show should display the user first_name in the info list' do
    get user_path(@user)
    assert_select 'dl.user-info dd', text: @user.first_name
  end

  test '#show should display the user last_name in the info list' do
    get user_path(@user)
    assert_select 'dl.user-info dd', text: @user.last_name
  end

  test '#show should display the user birthday in the info list' do
    get user_path(@user)
    assert_select 'dl.user-info dd', text: @user.birthday.to_s
  end

  test '#show should display the user gender in the info list' do
    get user_path(@user)
    assert_select 'dl.user-info dd', text: @user.gender
  end

  test '#show should display a link to edit the user if current user is the same' do
    get user_path(@user)
    assert_select 'a[href=?]', edit_user_path(@user)
    delete(destroy_user_session_path)
    post(user_session_path, params: { user: { email: 'other@hidden.org', password: 'secret' } })
    get user_path(@user)
    assert_select 'a[href=?]', edit_user_path(@user), 0
  end

  test '#show should display all posts for the user' do
    get user_path(@user)
    assert_not_nil assigns(:posts)
    assert_equal @user.posts.recents.paginate(page: controller.params[:page], per_page: 10), assigns(:posts)

    (assigns(:first_half) + assigns(:second_half)).each do |p|
      assert_select 'div.well h3', text: p.title
      assert_select 'div.well img[src=?]', @user.image_url + '?s=50'
      assert_select 'div.well a[href=?]', post_path(p)
      assert_select 'div.well p', match: /#{p.content[0...300]}/mi
    end
  end

  test '#show should display the total number of posts for the user' do
    get user_path(@user)
    assert_not_nil assigns(:posts)
    assert_select 'dt', text: 'Posts'
    assert_select 'dd', text: @user.posts.count.to_s
  end

  test '#show should display the total number of likes for his posts' do
    get user_path(@user)
    assert_select 'dt', text: 'Likes'
    assert_select 'dd', text: @user.total_likes.to_s
  end

  test 'should get #edit' do
    get edit_user_path(@user)
    assert_response(:success)
  end

  test '#edit should assign the @user' do
    get edit_user_path(@user)
    assert_equal @user, assigns(:user)
  end

  test '#edit should display a form' do
    get edit_user_path(@user)
    assert_select 'form'
  end

  test '#edit should display a first name text field' do
    get edit_user_path(@user)
    assert_select 'form input[type="text"]#user_first_name'
  end

  test '#edit should display a last name text field' do
    get edit_user_path(@user)
    assert_select 'form input[type="text"]#user_last_name'
  end

  test '#edit should display a gender select' do
    get edit_user_path(@user)
    assert_select 'form select#user_gender'
  end

  test '#edit should display a phone text field' do
    get edit_user_path(@user)
    assert_select 'form input[type="text"]#user_phone'
  end

  test '#edit should display a birthday date field' do
    get edit_user_path(@user)
    assert_select 'form input[type="date"]#user_birthday'
  end

  test '#edit should display a submit button' do
    get edit_user_path(@user)
    assert_select 'form button[type="submit"]'
  end

  test 'should patch #update' do
    patch(
      user_path(@user),
      params: {
        user: {
          first_name: 'Stuart',
          last_name: 'Keys'
        }
      }
    )
    assert_response(:redirect)
  end

  test 'should get #index' do
    get users_path
    assert_response(:success)
  end

  test '#index should set @users variable' do
    get users_path
    assert_not_nil assigns(:users)
  end

  test '#index should display all user names' do
    get users_path

    (assigns(:first_half) + assigns(:second_half)).each do |user|
      assert_select 'dt', text: 'Name'
      assert_select 'dd', text: "#{user.first_name} #{user.last_name}"
    end
  end

  test '#index should display a image linked to the profile' do
    get users_path

    (assigns(:first_half) + assigns(:second_half)).each do |user|
      assert_select 'a[href=?] > img[src=?]', user_path(user), user.image_url
    end
  end

  test '#index should display the number of posts of the user' do
    get users_path

    (assigns(:first_half) + assigns(:second_half)).each do |user|
      assert_select 'dt', text: 'Posts'
      assert_select 'dd', text: user.posts.count.to_s
    end
  end

  test '#index should display the number of likes for the user' do
    get users_path

    (assigns(:first_half) + assigns(:second_half)).each do |user|
      assert_select 'dt', text: 'Likes'
      assert_select 'dd', text: user.total_likes.to_s
    end
  end

  test '#friend_requests should return http success' do
    get friend_requests_user_path(@user)
    assert_response :success
  end

  test '#friend_requests sets @requests' do
    get friend_requests_user_path(@user)
    assert_not_nil assigns(:requests)
  end
end
# rubocop:enable Metrics/ClassLength
