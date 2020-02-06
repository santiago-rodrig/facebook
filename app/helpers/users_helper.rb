module UsersHelper
  def relation_with(user)
    included = user.friends.include?(current_user)
    friendship = user.friendships.find_by(friend_id: current_user.id)
    confirmed = friendship && friendship.confirmed?
    if  included && confirmed
      return 'Friend'
    elsif current_user.friends.include?(user) || user.friends.include?(current_user)
      return 'Pending friendship'
    elsif user == current_user
      return 'Yourself'
    else
      return 'Stranger'
    end
  end
end
