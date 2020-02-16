require 'rails_helper'

RSpec.feature 'UserCanEditAPosts', type: :feature do
  let(:user) do
    User.create(
      email: 'bob@example.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )
  end

  let(:post) { user.posts.create(title: 'This post', content: 'Is original') }

  before do
    sign_in(user)
  end

  it 'edits a post' do
    visit(edit_post_path(post))
    expect(page).to have_current_path(edit_post_path(post))
    expect(page).to have_content('Updating post')
    fill_in('Title', with: 'This edited post')
    fill_in('Content', with: 'Is edited')
    click_button('Update post')
    expect(page).to have_current_path(post_path(post))
    post.reload
    expect(post.title).to eq('This edited post')
    expect(post.content).to eq('Is edited')
  end
end
