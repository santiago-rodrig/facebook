require 'rails_helper'

RSpec.describe Comment, type: :model do
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

  it 'belongs to a commenter' do
    expect(Comment.new).to respond_to(:commenter)
    comment = user.comment(post, 'Yes it is')
    expect(comment.commenter).to eq(user)
  end

  it 'belongs to a commented_post' do
    expect(Comment.new).to respond_to(:commented_post)
    comment = user.comment(post, 'Yes it is')
    expect(comment.commented_post).to eq(post)
  end
end
