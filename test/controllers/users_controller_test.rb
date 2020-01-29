require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    post(
      user_registration_path,
      params: {
        user: {
          email: 'example@email.com',
          password: 'secret',
          password_confirmation: 'secret'
        }
      }
    )
    @user = User.last
  end

  test 'should get #show' do
    get user_path(@user)
    assert_response(:success)
  end

  test '#show should assign the @user' do
    get user_path(@user)
    assert_equal @user, assigns(:user)
  end

  test '#show should display Your Profile as a heading' do
    get user_path(@user)
    assert_select 'h1', text: 'Your Profile'
  end

  test '#show should display a user info list' do
    get user_path(@user)
    assert_select 'ul.user-info'
  end

  test '#show should display the user phone in the info list' do
    get user_path(@user)
    assert_select 'ul.user-info li', text: @user.phone
  end

  test '#show should display the user email in the info list' do
    get user_path(@user)
    assert_select 'ul.user-info li', text: @user.email
  end

  test '#show should display a link to edit the user' do
    get user_path(@user)
    assert_select 'a[href=?]', edit_user_path(@user)
  end

  test 'should get #edit' do
    get edit_user_path(@user)
    assert_response(:success)
  end

  test '#edit should assign the @user' do
    get edit_user_path(@user)
    assert_equal @user, assigns(:user)
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
    assert_response(:success)
  end
end
