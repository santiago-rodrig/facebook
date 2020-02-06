class Friendship < ApplicationRecord
  belongs_to :user, class_name: 'User'
  belongs_to :friend, class_name: 'User'
  scope :requesters, -> (user) { where('friend_id = ? AND NOT confirmed', user.id) }
end
