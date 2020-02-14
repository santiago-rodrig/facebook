require 'rails_helper'

RSpec.describe Post, type: :model do
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

  it 'belongs to an author' do
    expect(Post.new).to respond_to(:author)
    expect(post.author).to eq(user)
  end

  it 'has many likes' do
    expect(post).to respond_to(:likes)
    likes_count = Like.count

    like = post.likes.create(
      liker_id: user.id
    )

    expect(Like.count).to eq(likes_count + 1)
    expect(like.liked_post).to eq(post)
  end

  it 'has many likers' do
    expect(post).to respond_to(:likers)
    likes_count = Like.count
    user.like(post)
    expect(Like.count).to eq(likes_count + 1)
    expect(post.likers).to include(user)
  end

  it 'has many comments' do
    expect(post).to respond_to(:comments)
    comments_count = Comment.count

    comment = post.comments.create(
      commenter_id: user.id,
      body: 'Yes it is'
    )

    expect(Comment.count).to eq(comments_count + 1)
    expect(comment.commented_post).to eq(post)
  end

  it 'has many commenters' do
    expect(post).to respond_to(:commenters)
    comments_count = Comment.count
    post.commenters << user
    comment = Comment.last
    comment.update_attribute(:body, 'Yes it is')
    expect(Comment.count).to eq(comments_count + 1)
    expect(post.commenters).to include(user)
  end

  describe '::recents' do
    it 'returns the collection of posts ordered from newest to oldest' do
      user.posts.create([
        {
          title: 'This post 1',
          content: 'Is original'
        },
        {
          title: 'This post 2',
          content: 'Is also original'
        },
        {
          title: 'This post 3',
          content: 'Original as the others'
        }
      ])

      ordered = Post.all.order('created_at DESC')
      expect(Post.count).to eq(3)
      expect(Post.recents).to eq(ordered)
    end
  end
end
