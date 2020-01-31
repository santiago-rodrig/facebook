class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  scope :recents, -> { order('created_at DESC') }
end
