require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  test 'should belong to user' do
    assert_respond_to Friendship.new, :user
  end

  test 'should belong to friend' do
    assert_respond_to Friendship.new, :friend
  end

  test 'should have attribute cofirmed' do
    assert_includes Friendship.column_names, 'confirmed'
  end

  test 'should set confirmed to false by default' do
    assert_equal false, Friendship.new.confirmed?
  end

  test 'should have a scope for the friend requesters of a user' do
    user = User.create(
      email: 'example@host.net',
      password: 'secret',
      password_confirmation: 'secret',
      first_name: 'bob',
      last_name: 'sinclair'
    )

    other_user = User.create(
      email: 'empty@can.org',
      password: 'hidden',
      password_confirmation: 'hidden',
      first_name: 'sassy',
      last_name: 'jones'
    )

    other_user.friends << user
    assert_equal Friendship.where('friend_id = ? AND NOT confirmed', user.id), Friendship.requesters(user)
    assert_includes Friendship.requesters(user), other_user.friendships.first
  end
end
