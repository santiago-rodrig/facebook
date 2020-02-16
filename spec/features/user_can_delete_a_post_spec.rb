require 'rails_helper'

RSpec.feature "UserCanDeleteAPosts", type: :feature do
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

  it 'deletes a post' do
    visit(post_path(post))
    expect(page).to have_current_path(post_path(post))

    expect(page).to(
      have_selector(
        "a[href=\"#{post_path(post)}\"][data-method=\"delete\"]"
      )
    )

    expect(page).to have_content('Delete')

    accept_confirm do
      click_link('Delete')
    end

    expect(page).to have_current_path(root_path)
    expect(page).to have_content('Post deleted')
  end
end
