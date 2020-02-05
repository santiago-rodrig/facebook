class Comment < ApplicationRecord
  belongs_to :commenter, class_name: 'User'
  belongs_to :commented_post, class_name: 'Post'
end
