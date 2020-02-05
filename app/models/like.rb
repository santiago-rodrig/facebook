class Like < ApplicationRecord
  belongs_to :liker, class_name: 'User'
  belongs_to :liked_post, class_name: 'Post'
end
