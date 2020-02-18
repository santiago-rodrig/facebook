class User < ApplicationRecord
  # set image_url on saving
  before_save -> { self.image_url = 'https://www.gravatar.com/avatar/' + Digest::MD5.hexdigest(email) }
  # posts association
  has_many :posts, foreign_key: 'author_id'
  # likes association
  has_many :likes, foreign_key: 'liker_id'
  has_many :liked_posts, through: :likes, source: :liked_post
  # comments association
  has_many :comments, foreign_key: 'commenter_id'
  has_many :commented_posts, through: :comments, source: :commented_post
  # friends association
  has_many :friendships, foreign_key: 'user_id'
  has_many :friends, through: :friendships, source: :friend
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :omniauthable, omniauth_providers: %i[facebook]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = first_name_from_auth(auth.info.name)
      user.last_name = last_name_from_auth(auth.info.name)
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def full_name
    return 'Anonymous' unless first_name || last_name

    first_name.to_s + ' ' + last_name.to_s
  end

  def like(post)
    liked_posts << post
  end

  def unlike(post)
    liked_posts.delete(post)
  end

  def comment(post, body)
    comments.create(body: body, commented_post_id: post.id)
  end

  def total_likes
    posts.inject(0) { |t, p| t + p.likers.count }
  end

  def friend_requests_count
    Friendship.requesters(self).count
  end

  def accept_friend(friend)
    friends << friend
    friendships.find_by(friend_id: friend.id).toggle!(:confirmed)
    friend.friendships.find_by(friend_id: id).toggle!(:confirmed)
  end

  def reject_friend(friend)
    friend.friends.delete(self)
  end

  def cancel_friend(friend)
    friend.friends.delete(self)
    friends.delete(friend)
  end

  def real_friends
    ids = friendships.where('confirmed').map(&:friend_id)
    User.where(id: ids)
  end

  def feed
    ids = real_friends.map(&:id)
    ids << id
    Post.where(author_id: ids)
  end

  private

  def self.first_name_from_auth(name)
    name.match(/(\S+)/).captures.first
  end

  def self.last_name_from_auth(name)
    name.match(/.*\s+(\S+).*/).captures.first
  end
end
