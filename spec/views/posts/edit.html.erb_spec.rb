require 'rails_helper'

RSpec.describe 'posts/edit', type: :view do
  before do
    @user = User.create(
      email: 'bob@example.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )

    sign_in(@user)

    @post = @user.posts.create(
      title: 'The post',
      content: 'Has content'
    )

    assign(:post, @post)
    render
  end

  it 'displays a form' do
    expect(rendered).to have_selector('form')
  end

  it 'displays a text field for the title' do
    expect(rendered).to(
      have_selector("input[type=\"text\"][value=\"#{@post.title}\"]#post_title")
    )
  end

  it 'displays a textarea for the content' do
    expect(rendered).to(
      have_selector('textarea#post_content')
    )

    expect(rendered).to(
      match(
        %r{.*<textarea.*>.*#{@post.content}.*</textarea>.*}mi
      )
    )
  end

  it 'displays a submit button' do
    expect(rendered).to have_selector('button[type="submit"]')
  end
end
