class User < ApplicationRecord
  before_save -> { self.image_url = 'https://www.gravatar.com/avatar/' + Digest::MD5.hexdigest(email) }
  has_many :posts, foreign_key: 'author_id'
  has_many :likes, foreign_key: 'liker_id'
  has_many :liked_posts, through: :likes, source: :liked_post
  has_many :comments, foreign_key: 'commenter_id'
  has_many :commented_posts, through: :comments, source: :commented_post
  validates :first_name, :last_name, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :omniauthable, omniauth_providers: %i[facebook]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def full_name
    first_name + ' ' + last_name
  end

  def like(post)
    self.liked_posts << post
  end

  def unlike(post)
    self.liked_posts.delete(post)
  end
end
