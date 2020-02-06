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

  test '#friend_requests displays a list of requesters' do
    get friend_requests_user_path(@user)
    assigns(:requests).each do |r|
      assert_select 'div.well a[href=?] img[src=?]', user_path(r.user), r.user.image_url
      assert_select 'div.well p', match: /.*#{r.user.name}/mi
    end
  end
end
