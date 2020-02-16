require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.feature 'UserCanAskAFriendships', type: :feature do
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
      email: 'alice@example.com',
      first_name: 'alice',
      last_name: 'wonderland',
      password: 'rabbit',
      password_confirmation: 'rabbit'
    )
  end

  before do
    sign_in(user)
    sign_out(user)
    sign_in(other_user)
    sign_out(other_user)
    sign_in(user)
  end

  it 'asks for a friendship' do
    visit(users_path)
    friends_count = user.friends.count
    find_link(href: ask_friendship_path(friend_id: other_user.id)).click
    [user, other_user].each(&:reload)
    expect(user.friends.count).to eq(friends_count + 1)
    expect(user.friends).to include(other_user)
    friendship = Friendship.find_by(user_id: user.id, friend_id: other_user.id)
    expect(friendship).not_to be_confirmed
    expect(Friendship.requesters(other_user)).to include(friendship)
    expect(page).to have_current_path(users_path)
  end
end
# rubocop:enable Metrics/BlockLength
