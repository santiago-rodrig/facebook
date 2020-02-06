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
    assert_equal "you and #{@other_user.full_name} are now friends!", flash[:success]
  end

  test '#reject_friend_request should delete the friendship' do
    delete(reject_friend_request_user_path(id: @user.id, friend_id: @other_user.id))
    assert_nil @other_user.friendships.find_by(friend_id: @user.id)
  end

  test '#reject_friend_request should redirect to friend_requests' do
    delete(reject_friend_request_user_path(id: @user.id, friend_id: @other_user.id))
    assert_redirected_to friend_requests_user_path(@user)
  end

  test '#reject_friend_request should display a flash message after redirecting' do
    delete(reject_friend_request_user_path(id: @user.id, friend_id: @other_user.id))
    follow_redirect!
    assert_equal "you rejected #{@other_user.full_name} friendship proposal", flash[:info]
  end

  test 'users#index should display links to ask for friendship if the user is not a friend' do
    get users_path

    (assigns(:first_half) + assigns(:second_half)).each do |u|
      if u != @user && !@user.real_friends.include?(u)
        assert_select 'a[href=?].btn.btn-primary', ask_friendship_user_path(id: @user.id, friend_id: u.id)
      end
    end
  end

  test 'users#ask_friendship should create a pending friedship request' do
    assert_difference '@user.friends.count' do
      post(ask_friendship_user_path(id: @user.id, friend_id: @other_user.id))
    end
  end

  test 'users#index should display the relation status for each user' do
    get users_path

    (assigns(:users) + assigns(:second_half)).each do |u|
      assert_select 'dt', text: 'Relation'

      if @user.real_friends.include?(u)
        assert_select 'dd', text: 'Friends'
      elsif u == @user
        assert_select 'dd', text: 'Yourself'
      else
        assert_select 'dd', text: 'Stranger'
      end
    end
  end

  test 'users#friends_index should return http success' do
    get friends_user_path(@user)
    assert_response :success
  end

  test 'users#friends sets users variable' do
    @other_user.friendships.first.toggle!(:confirmed)
    get friends_user_path(@user)
    assert_not_nil assigns(:users)
    assert_equal @user.real_friends.paginate(page: controller.params[:page], per_page: 12), assigns(:users)
  end

  test 'users#friend sets the title variable' do
    get friends_user_path(@user)
    assert_equal 'Your friends', assigns(:title)
  end

  test 'users#friend sets the partial variable' do
    get friends_user_path(@user)
    assert_equal 'friend', assigns(:partial)
  end

  test 'users#friends sets first_half and second_half' do
    @other_user.friendships.first.toggle!(:confirmed)
    get friends_user_path(@user)
    assert_not_nil assigns(:first_half)
    assert_not_nil assigns(:second_half)

    if controller.params[:page]
      assert_equal assigns(:users).offset(12 * (params[:page].to_i - 1)).first(6), assigns(:first_half)
      assert_equal assigns(:users).offset(12 * (params[:page].to_i - 1) + 6).first(6), assigns(:second_half)
    else
      assert_equal assigns(:users).first(6), assigns(:first_half)
      assert_equal assigns(:users).offset(6).first(6), assigns(:second_half)
    end
  end

  test 'users#friends list all friends' do
    @other_user.friendships.first.toggle!(:confirmed)
    get friends_user_path(@user)

    (assigns(:first_half) + assigns(:second_half)).each do |f|
      assert_select 'a[href=?] img[src=?]', user_path(f), f.image_url
      assert_select 'dt', text: 'Name'
      assert_select 'dd', text: f.full_name
      assert_select 'dt', text: 'Posts'
      assert_select 'dd', text: f.posts.count.to_s
      assert_select 'dt', text: 'Likes'
      assert_select 'dd', text: f.total_likes.to_s
    end
  end

  test 'users#friends list all friends with links to cancel friendship' do
    @other_user.friendships.first.toggle!(:confirmed)
    get friends_user_path(@user)

    (assigns(:first_half) + assigns(:second_half)).each do |f|
      assert_select 'a[href=?]', cancel_friendship_user_path(id: @user.id, friend_id: f.id)
    end
  end

  test 'users#cancel_friendship deletes the friendship' do
    @other_user.friendships.first.toggle!(:confirmed)
    assert_difference('@other_user.friends.count', -1) do
      delete(cancel_friendship_user_path(id: @user.id, friend_id: @other_user.id))
    end
  end

  test 'users#cancel_friendship redirects to users#friends' do
    @other_user.friendships.first.toggle!(:confirmed)
    delete(cancel_friendship_user_path(id: @user.id, friend_id: @other_user.id))
    assert_redirected_to friends_user_path(@user)
  end
end
