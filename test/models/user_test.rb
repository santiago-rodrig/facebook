require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'it has email as an attribute' do
    assert User.column_names.include? 'email'
  end

  test 'it has encrypted_password as an attribute' do
    assert User.column_names.include? 'encrypted_password'
  end

  test 'it has reset_password_token as an attribute' do
    assert User.column_names.include? 'reset_password_token'
  end

  test 'it has reset_password_set_at as an attribute' do
    assert User.column_names.include? 'reset_password_sent_at'
  end

  test 'it has remember_created_at as an attribute' do
    assert User.column_names.include? 'remember_created_at'
  end

  test 'it has a first_name attribute' do
    assert User.column_names.include? 'first_name'
  end

  test 'it has a last_name attribute' do
    assert User.column_names.include? 'last_name'
  end

  test 'it has a birthday attribute' do
    assert User.column_names.include? 'birthday'
  end

  test 'it has a phone attribute' do
    assert User.column_names.include? 'phone'
  end

  test 'it has a image_url attribute' do
    assert User.column_names.include? 'image_url'
  end

  test 'it has a gender attribute' do
    assert User.column_names.include? 'gender'
  end

  test 'it has a provider attribute' do
    assert User.column_names.include? 'provider'
  end

  test 'it has a uid attribute' do
    assert User.column_names.include? 'uid'
  end

  test 'before saving sets image_url' do
    @user = User.create(
      email: 'example@host.net',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )

    assert_equal(
      @user.image_url,
      'https://www.gravatar.com/avatar/' + Digest::MD5.hexdigest('example@host.net')
    )
  end

  test 'it has many posts' do
    assert_respond_to User.new, :posts
  end

  test 'it has many likes' do
    assert_respond_to User.new, :likes
  end

  test 'it has many liked_posts' do
    assert_respond_to User.new, :liked_posts
  end

  test 'it can like a post' do
    assert_respond_to User.new, :like
  end

  test 'it can unlike a post' do
    assert_respond_to User.new, :unlike
  end

  test 'it has many commented_posts' do
    assert_respond_to User.new, :commented_posts
  end

  test 'it can comment on a post' do
    assert_respond_to User.new, :comment
  end

  test 'it has many friends' do
    assert_respond_to User.new, :friends
  end

  test 'it has feed collection of posts' do
    assert_respond_to User.new, :feed
  end

  test '#accept friend confirms both friendships and create a new one' do
    @user = User.create(
      email: 'bob@example.net',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )

    @other = User.create(
      email: 'elena@example.org',
      first_name: 'elena',
      last_name: 'guthrie',
      password: 'pirate',
      password_confirmation: 'pirate'
    )

    @other.friends << @user

    assert_difference('Friendship.count') do
      @user.accept_friend(@other)
    end

    assert @user.friendships.find_by(friend_id: @other.id).confirmed?
    assert @other.friendships.find_by(friend_id: @user.id).confirmed?
  end

  test '#reject_friend deletes the friendship and clears friends' do
    @user = User.create(
      email: 'bob@example.net',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )

    @other = User.create(
      email: 'elena@example.org',
      first_name: 'elena',
      last_name: 'guthrie',
      password: 'pirate',
      password_confirmation: 'pirate'
    )

    @other.friends << @user

    assert_difference('Friendship.count', -1) do
      @user.reject_friend(@other)
    end

    assert_not @other.friends.include?(@user)
  end

  test '#cancel_friend deletes friendship on both ends' do
    @user = User.create(
      email: 'bob@example.net',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )

    @other = User.create(
      email: 'elena@example.org',
      first_name: 'elena',
      last_name: 'guthrie',
      password: 'pirate',
      password_confirmation: 'pirate'
    )

    @other.friends << @user
    @user.accept_friend(@other)

    assert_difference('Friendship.count', -2) do
      @user.cancel_friend(@other)
    end

    @user.cancel_friend(@other)
    assert_not @user.friends.include?(@other)
    assert_not @other.friends.include?(@user)
  end
end
