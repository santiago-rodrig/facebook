require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.feature 'UserCanAcceptAFriendships', type: :feature do
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
    other_user.friends << user
  end

  it 'accepts a friendship' do
    visit(friend_requests_path)

    expect(page).to have_selector(
      "a[href=\"#{accept_friend_request_path(friend_id: other_user.id)}\"]"
    )

    expect(user.friends).not_to include(other_user)
    find_link(href: accept_friend_request_path(friend_id: other_user.id)).click
    [user, other_user].each(&:reload)
    expect(user.friends).to include(other_user)

    friendship_from = Friendship.find_by(
      user_id: other_user.id, friend_id: user.id
    )

    friendship_to = Friendship.find_by(
      user_id: user.id, friend_id: other_user.id
    )

    expect(friendship_from).to be_confirmed
    expect(friendship_to).to be_confirmed
  end
end
# rubocop:enable Metrics/BlockLength
