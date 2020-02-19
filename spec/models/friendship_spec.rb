require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:user) do
    User.create(
      email: 'bob@example.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )
  end

  let(:other_user) do
    User.create(
      email: 'alice@example.gov',
      first_name: 'alice',
      last_name: 'wonderland',
      password: 'rabbit',
      password_confirmation: 'rabbit'
    )
  end

  it 'belongs to a user' do
    expect(Friendship.new).to respond_to(:user)

    friendship = user.friendships.create(
      friend_id: other_user.id
    )

    expect(friendship.user).to eq(user)
  end

  it 'belongs to a friend' do
    expect(Friendship.new).to respond_to(:friend)

    friendship = user.friendships.create(
      friend_id: other_user.id
    )

    expect(friendship.friend).to eq(other_user)
  end

  describe '::requesters' do
    it 'responds to the call' do
      expect(Friendship).to respond_to(:requesters)
    end

    context 'no requesters' do
      it 'returns an empty collection' do
        expect(Friendship.requesters(user)).to be_empty
      end
    end

    context 'requesters' do
      it 'returns the collection of unconfirmed friendships' do
        other_user.friends << user

        friendship = Friendship.find_by(
          user_id: other_user.id,
          friend_id: user.id
        )

        expect(Friendship.requesters(user)).to include(friendship)
      end
    end
  end
end
