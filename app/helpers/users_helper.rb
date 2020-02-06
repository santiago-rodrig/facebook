module UsersHelper
  def relation_with(user)
    included = user.friends.include?(current_user)
    friendship = user.friendships.find_by(friend_id: current_user.id)
    confirmed = friendship&.confirmed?
    if included && confirmed
      'Friend'
    elsif current_user.friends.include?(user) || user.friends.include?(current_user)
      'Pending friendship'
    elsif user == current_user
      'Yourself'
    else
      'Stranger'
    end
  end
end
