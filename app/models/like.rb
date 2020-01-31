class Like < ApplicationRecord
  belongs_to :liker
  belongs_to :liked_post
end
