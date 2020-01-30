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
    assert_select 'dl.user-info'
  end

  test '#show should display the user phone in the info list' do
    get user_path(@user)
    assert_select 'dl.user-info dd', text: @user.phone
  end

  test '#show should display the user email in a paragraph' do
    get user_path(@user)
    assert_select 'p', match: /#{@user.email}/
  end

  test '#show should display a link to edit the registration info' do
    get user_path(@user)
    assert_select 'a[href=?]', edit_user_registration_path(@user)
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
end
