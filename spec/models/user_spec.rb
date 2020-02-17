require 'rails_helper'

RSpec.describe User, type: :model do
  context 'creating a user' do
    let(:user) do
      User.create(
        email: 'bob@example.com',
        first_name: 'bob',
        last_name: 'sinclair',
        password: 'secret',
        password_confirmation: 'secret'
      )
    end

    it 'sets image_url to the gravatar image' do
      expect(user.image_url).to(
        eq(
          'https://www.gravatar.com/avatar/' +
            Digest::MD5.hexdigest(user.email)
        )
      )
    end
  end

  let(:user) do
    User.create(
      email: 'bob@example.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )
  end

  it 'is has_many posts' do
    expect(user).to respond_to(:posts)

    post_count = Post.count

    post = user.posts.create(
      title: 'This post',
      content: 'Is original'
    )

    expect(Post.count).to eq(post_count + 1)
    expect(post.author).to eq(user)
  end

  it 'has many likes' do
    expect(user).to respond_to(:likes)

    post = user.posts.create(
      title: 'This post',
      content: 'Is original'
    )

    likes_count = Like.count

    like = user.likes.create(
      liked_post_id: post.id
    )

    expect(Like.count).to eq(likes_count + 1)
    expect(like.liker).to eq(user)
    expect(like.liked_post).to eq(post)
  end

  it 'has many liked_posts' do
    expect(user).to respond_to(:liked_posts)

    post = user.posts.create(
      title: 'This post',
      content: 'Is original'
    )

    likes_count = Like.count
    user.liked_posts << post
    expect(Like.count).to eq(likes_count + 1)
    expect(user.liked_posts).to include(post)
    expect(post.likers).to include(user)
  end

  it 'has many comments' do
    expect(user).to respond_to(:comments)

    post = user.posts.create(
      title: 'This post',
      content: 'Is original'
    )

    comments_count = Comment.count

    comment = user.comments.create(
      commented_post_id: post.id,
      body: 'Yes it is'
    )

    expect(Comment.count).to eq(comments_count + 1)
    expect(comment.commenter).to eq(user)
    expect(comment.commented_post).to eq(post)
  end

  it 'has many commented posts' do
    expect(user).to respond_to(:commented_posts)

    post = user.posts.create(
      title: 'This post',
      content: 'Is original'
    )

    comments_count = Comment.count
    user.commented_posts << post
    comment = Comment.last
    comment.update_attribute(:body, 'Yes it is')
    expect(Comment.count).to eq(comments_count + 1)
    expect(user.commented_posts).to include(post)
    expect(post.commenters).to include(user)
  end

  it 'has many friendships' do
    expect(user).to respond_to(:friendships)

    other_user = User.create(
      email: 'alice@example.com',
      first_name: 'alice',
      last_name: 'wonderland',
      password: 'rabbit',
      password_confirmation: 'rabbit'
    )

    friendships_count = Friendship.count

    friendship = user.friendships.create(
      friend_id: other_user.id
    )

    expect(Friendship.count).to eq(friendships_count + 1)
    expect(friendship.user).to eq(user)
    expect(friendship.friend).to eq(other_user)
  end

  it 'has many friends' do
    expect(user).to respond_to(:friends)

    other_user = User.create(
      email: 'alice@example.com',
      first_name: 'alice',
      last_name: 'wonderland',
      password: 'rabbit',
      password_confirmation: 'rabbit'
    )

    friendships_count = Friendship.count
    user.friends << other_user
    expect(Friendship.count).to eq(friendships_count + 1)
    friendship = Friendship.find_by(user_id: user.id, friend_id: other_user.id)
    expect(friendship.user).to eq(user)
    expect(friendship.friend).to eq(other_user)
    expect(user.friends.find(other_user.id)).to eq(other_user)
  end

  describe '#full_name' do
    it 'returns the full name' do
      expect(user).to respond_to(:full_name)
      expect(user.full_name).to eq(user.first_name + ' ' + user.last_name)
    end
  end

  describe '#like' do
    it 'likes a post' do
      post = user.posts.create(
        title: 'This post',
        content: 'Is original'
      )

      expect(user).to respond_to(:like)
      liked_posts_count = user.liked_posts.count
      user.like(post)
      expect(user.liked_posts.count).to eq(liked_posts_count + 1)
      expect(user.liked_posts).to include(post)
    end
  end

  describe '#unlike' do
    it 'dislikes a post' do
      post = user.posts.create(
        title: 'This post',
        content: 'Is original'
      )

      expect(user).to respond_to(:unlike)
      user.liked_posts << post
      liked_posts_count = user.liked_posts.count
      user.unlike(post)
      expect(user.liked_posts.count).to eq(liked_posts_count - 1)
      expect(user.liked_posts).not_to include(post)
    end
  end

  describe '#comment' do
    it 'comments a post' do
      expect(user).to respond_to(:comment)

      post = user.posts.create(
        title: 'This post',
        content: 'Is original'
      )

      comments_count = Comment.count
      user.comment(post, 'Yes it is')
      expect(Comment.count).to eq(comments_count + 1)
      expect(user.commented_posts).to include(post)
    end
  end

  describe '#total_likes' do
    it 'returns the accumulated likes for the user' do
      expect(user).to respond_to(:total_likes)

      post = user.posts.create(
        title: 'This post',
        content: 'Is original'
      )

      user.like(post)
      expect(user.total_likes).to eq(1)

      other_user = User.create(
        email: 'alice@example.com',
        first_name: 'alice',
        last_name: 'wonderland',
        password: 'rabbit',
        password_confirmation: 'rabbit'
      )

      other_user.like(post)
      expect(user.total_likes).to eq(2)

      other_post = user.posts.create(
        title: 'The great savannah',
        content: 'Has lots of animals'
      )

      other_user.like(other_post)
      expect(user.total_likes).to eq(3)
      other_user.unlike(post)
      expect(user.total_likes).to eq(2)
    end
  end

  describe '#friend_requests_count' do
    it 'returns the total number of friendship with user requesters' do
      other_user = User.create(
        email: 'alice@example.com',
        first_name: 'alice',
        last_name: 'wonderland',
        password: 'rabbit',
        password_confirmation: 'rabbit'
      )

      other_user.friends << user
      expect(user.friend_requests_count).to eq(1)

      another_user = User.create(
        email: 'jeremy@example.net',
        first_name: 'jeremy',
        last_name: 'stocks',
        password: 'hidden',
        password_confirmation: 'hidden'
      )

      another_user.friends << user
      expect(user.friend_requests_count).to eq(2)
    end
  end

  describe '#accept_friend' do
    it 'settles the friendship between the users' do
      expect(user).to respond_to(:accept_friend)

      other_user = User.create(
        email: 'alice@example.com',
        first_name: 'alice',
        last_name: 'wonderland',
        password: 'rabbit',
        password_confirmation: 'rabbit'
      )

      other_user.friends << user
      friendships_count = Friendship.count
      user.accept_friend(other_user)
      expect(Friendship.count).to eq(friendships_count + 1)
      expect(user.friends).to include(other_user)
      expect(other_user.friends).to include(user)

      friendship_from = Friendship.find_by(
        user_id: other_user.id,
        friend_id: user.id
      )

      friendship_to = Friendship.find_by(
        user_id: user.id,
        friend_id: other_user.id
      )

      expect(friendship_from).to be_confirmed
      expect(friendship_to).to be_confirmed
    end
  end

  describe '#reject_friend' do
    it 'cancels the friend request' do
      other_user = User.create(
        email: 'alice@example.com',
        first_name: 'alice',
        last_name: 'wonderland',
        password: 'rabbit',
        password_confirmation: 'rabbit'
      )

      expect(user).to respond_to(:reject_friend)
      other_user.friends << user
      requests_count = user.friend_requests_count
      user.reject_friend(other_user)
      expect(user.friend_requests_count).to eq(requests_count - 1)
      expect(other_user.friends).not_to include(user)
    end
  end

  describe '#real_friends' do
    it 'returns the collection of confirmed friends' do
      other_user = User.create(
        email: 'alice@example.com',
        first_name: 'alice',
        last_name: 'wonderland',
        password: 'rabbit',
        password_confirmation: 'rabbit'
      )

      expect(user).to respond_to(:real_friends)
      expect(user.real_friends).to be_empty
      other_user.friends << user
      user.accept_friend(other_user)
      expect(user.real_friends).to include(other_user)
    end
  end

  describe '#feed' do
    it 'returns the posts from friends and one itself' do
      expect(user).to respond_to(:feed)
      expect(user.feed).to be_empty

      other_user = User.create(
        email: 'alice@example.com',
        first_name: 'alice',
        last_name: 'wonderland',
        password: 'rabbit',
        password_confirmation: 'rabbit'
      )

      user_post = user.posts.create(
        title: 'This post',
        content: 'Is original'
      )

      expect(user.feed).to include(user_post)

      other_user_post = other_user.posts.create(
        title: 'The greate savannah',
        content: 'Has lots of animals'
      )

      expect(user.feed).not_to include(other_user_post)
      other_user.friends << user
      user.accept_friend(other_user)
      expect(user.feed).to include(other_user_post)
      expect(other_user.feed).to include(user_post)
    end
  end
end
