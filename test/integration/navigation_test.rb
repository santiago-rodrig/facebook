require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest
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

  test 'it displays a friend requests link' do
    get root_path
    assert_select 'ul.nav.navbar-nav.navbar-right li a[href=?]', friend_requests_user_path(@user)
  end

  test 'it displays the number of friend requests without checking' do
    @other_user.friends << @user
    get root_path
    assert_select 'ul.nav.navbar-nav.navbar-right li a span.badge', match: /.*#{Friendship.requesters(@user).count}.*/
  end
end
