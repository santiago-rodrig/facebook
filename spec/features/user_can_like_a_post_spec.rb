require 'rails_helper'

RSpec.feature 'UserCanLikeAPosts', type: :feature do
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

  it 'likes a post' do
    visit(post_path(post))
    like_count = post.likers.count
    find_link(href: like_post_path(post_id: post)).click
    expect(page).to have_current_path(post_path(post))
    post.reload
    user.reload
    expect(post.likers.count).to eq(like_count + 1)
  end
end
