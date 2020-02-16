require 'rails_helper'

RSpec.feature "UserCanRejectAFriendships", type: :feature do
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

  it 'rejects a friendship' do
    visit(friend_requests_path)

    expect(page).to have_selector(
      "a[href=\"#{reject_friend_request_path(friend_id: other_user.id)}\"]"
    )

    expect(other_user.friends).to include(user)
    find_link(href: reject_friend_request_path(friend_id: other_user.id)).click
    [user, other_user].each { |e| e.reload }
    expect(other_user.friends).not_to include(user)
    expect(user.friends).not_to include(other_user)
    expect(page).to have_current_path(friend_requests_path)

    expect(page).to have_content(
      "you rejected #{other_user.full_name} friendship proposal"
    )
  end
end
