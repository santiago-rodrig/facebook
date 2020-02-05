class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :likes, foreign_key: 'liked_post_id'
  has_many :likers, through: :likes, source: :liker
  has_many :comments, foreign_key: 'commented_post_id'
  has_many :commenters, through: :comments, source: :commenter
  scope :recents, -> { order('created_at DESC') }
end
