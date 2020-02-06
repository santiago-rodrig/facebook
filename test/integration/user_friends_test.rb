require 'test_helper'

class UserFriendsTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(
      email: 'john@example.com',
      password: 'secret',
      password_confirmation: 'secret',
      first_name: 'john',
      last_name: 'doe'
    )

    @other_user = User.create(
      email: 'sassy@domain.net',
      password: 'hidden',
      password_confirmation: 'hidden',
      first_name: 'sassy',
      last_name: 'jones'
    )

    @other_user.friends << @user

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

  test '#friend_requests should return http success' do
    get friend_requests_user_path(@user)
    assert_response :success
  end

  test '#friend_requests sets @requests' do
    get friend_requests_user_path(@user)
    assert_not_nil assigns(:requests)
  end

  test '#friend_requests displays a proper heading' do
    get friend_requests_user_path(@user)
    assert_select 'h1', text: 'Your friend requests'
  end

  test '#friend_requests displays a list of requesters' do
    get friend_requests_user_path(@user)

    assigns(:requests).each do |r|
      assert_select 'dl dt', text: 'Name'
      assert_select 'dl dd', text: r.user.full_name
      assert_select 'div.well a[href=?] img[src=?]', user_path(r.user), r.user.image_url
    end
  end

  test '#friend_requests displays a list of requesters with accept and reject links' do
    get friend_requests_user_path(@user)

    assigns(:requests).each do |r|
      assert_select 'div.well a[href=?].btn.btn-success', accept_friend_request_user_path(id: @user.id, friend_id: r.user.id), text: 'Accept'
      assert_select 'div.well a[href=?].btn.btn-danger', reject_friend_request_user_path(id: @user.id, friend_id: r.user.id), text: 'Reject'
    end
  end

  test '#accept_friend_request should confirm the friendship' do
    post(accept_friend_request_user_path(id: @user.id, friend_id: @other_user.id))
    assert @other_user.friendships.find_by(friend_id: @user.id).confirmed?
  end

  test '#accept_friend_request should redirect to friend_requests' do
    post(accept_friend_request_user_path(id: @user.id, friend_id: @other_user.id))
    assert_redirected_to friend_requests_user_path(@user)
  end

  test '#accept_friend_request should display a flash message after redirecting' do
    post(accept_friend_request_user_path(id: @user.id, friend_id: @other_user.id))
    follow_redirect!
    assert_equal "Success: you and #{@other_user.full_name} are now friends!", flash[:success]
  end

  test '#reject_friend_request should delete the friendship' do
    delete(reject_friend_request_user_path(id: @user.id, friend_id: @other_user.id))
    assert_nil @other_user.friendships.find_by(friend_id: @user.id)
  end

  test '#reject_friend_request should redirect to friend_requests' do
    delete(reject_friend_request_user_path(id: @user.id, friend_id: @other_user.id))
    assert_redirected_to friend_requests_user_path(@user)
  end

  test '#reject_friend_request shoulddisplay a flash message after redirecting' do
    delete(reject_friend_request_user_path(id: @user.id, friend_id: @other_user.id))
    follow_redirect!
    assert_equal "Info: you rejected #{@other_user.full_name} friendship proposal", flash[:info]
  end
end
