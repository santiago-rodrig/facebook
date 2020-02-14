module UsersHelper
  def relation_with(user, other_user)
    included = other_user.friends.include?(user)
    friendship = other_user.friendships.find_by(friend_id: user.id)

    requested = user.friends.include?(other_user) ||
      other_user.friends.include?(user)

    confirmed = friendship&.confirmed?

    if included && confirmed
      'Friend'
    elsif requested
      'Pending friendship'
    elsif user == other_user
      'Yourself'
    else
      'Stranger'
    end
  end
end
