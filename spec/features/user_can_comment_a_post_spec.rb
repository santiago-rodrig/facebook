require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.feature 'UserCanCommentAPosts', type: :feature do
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

  it 'comments a post' do
    visit(post_path(post))
    expect(page).to have_content('What do you think?')

    expect(page.html).to match(
      %r{.*<label.*for="comment_body".*>.*What do you think\?.*</label>.*}mi
    )

    expect(page).to have_selector('textarea#comment_body')
    expect(page).to have_content('Comment')
    expect(page).to have_selector('button[type="submit"]')
    fill_in('What do you think?', with: 'Indeed is original')
    comments_count = post.commenters.count
    click_button('Comment')
    [user, post].each(&:reload)
    expect(post.commenters.count).to eq(comments_count + 1)
    expect(post.commenters).to include(user)
    expect(page).to have_current_path(post_path(post))
    expect(page).to have_content(user.full_name)
    expect(page).to have_content('Indeed is original')
  end
end
# rubocop:enable Metrics/BlockLength
