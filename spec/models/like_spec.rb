require 'rails_helper'

RSpec.describe Like, type: :model do
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

  it 'belongs to a liker' do
    expect(Like.new).to respond_to(:liker)

    like = user.likes.create(
      liked_post_id: post.id
    )

    expect(like.liker).to eq(user)
  end

  it 'belongs to a liked_post' do
    expect(Like.new).to respond_to(:liked_post)

    like = user.likes.create(
      liked_post_id: post.id
    )

    expect(like.liked_post).to eq(post)
  end
end
