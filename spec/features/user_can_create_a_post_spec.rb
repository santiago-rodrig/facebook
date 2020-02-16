require 'rails_helper'

RSpec.feature 'UserCanCreateAPosts', type: :feature do
  let(:user) do
    User.create(
      email: 'bob@example.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )
  end

  it 'creates a post' do
    visit(new_user_session_path)
    fill_in('Email', with: user.email)
    fill_in('Password', with: 'secret')
    click_button('Log in')
    click_link('Create a post')
    expect(page).to have_current_path(new_post_path)
    fill_in('Title', with: 'This post')
    fill_in('Content', with: 'Is original')
    post_count = Post.count
    click_button('Create post')
    expect(Post.count).to eq(post_count + 1)
    expect(Post.last.author).to eq(user)
    expect(page).to have_current_path(post_path(Post.last))
    expect(page).to have_content('Post created')
  end
end
