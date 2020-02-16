require 'rails_helper'

RSpec.feature "UserCanCancelFriendships", type: :feature do
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
    user.accept_friend(other_user)
  end

  it 'cancels a friendship' do
    visit(friends_path)

    expect(page).to have_selector(
      "a[href=\"#{cancel_friendship_path(friend_id: other_user.id)}\"]"
    )

    expect(user.friends).to include(other_user)
    find_link(href: cancel_friendship_path(friend_id: other_user.id)).click
    expect(page).to have_current_path(friends_path)
    [user, other_user].each { |e| e.reload }
    expect(user.friends).not_to include(other_user)
    expect(other_user.friends).not_to include(other_user)

    expect(page).to have_content(
      "you and #{other_user.full_name} are no longer friends :("
    )
  end
end
