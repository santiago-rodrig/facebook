require 'rails_helper'

RSpec.feature 'UserCanDislikeAPosts', type: :feature do
  let(:user) do
    User.create(
      email: 'bob@example.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )
  end

  let(:post) do
    user.posts.create(
      title: 'This post',
      content: 'Is original'
    )
  end

  before do
    sign_in(user)
  end

  it 'dislikes a post' do
    visit(post_path(post))
    find_link(href: like_post_path(post_id: post.id)).click
    like_count = post.likers.count
    find_link(href: unlike_post_path(post_id: post.id)).click
    expect(page).to have_current_path(post_path(post))
    [post, user].each(&:reload)
    expect(post.likers.count).to eq(like_count - 1)
  end
end
