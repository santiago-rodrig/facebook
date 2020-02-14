module FriendshipsHelper
  def ask_frienship(friend)
    not_the_same = current_user != friend
    not_a_friend = !current_user.real_friends.include?(friend)
    not_requested = !current_user.friends.include?(friend)
    not_all_three = not_the_same && not_a_friend && not_requested

    ask_button = <<-BTN
      <div class="cleared pull-right">
        #{link_to 'Ask friendship', ask_friendship_path(user_id: current_user.id, friend_id: friend.id), method: :post, class: 'btn btn-primary'}
      </div>
    BTN

    return unless not_all_three

    ask_button.html_safe
  end

  def put_requests(requests)
    if requests.any?
      render partial: 'friendships/request', collection: requests
    else
      msg_emty = <<-EMPTY
        <div class="col-sm-6 col-sm-offset-3">
          <div class="alert alert-info">
            You have no friend requests.
          </div>
        </div>
      EMPTY

      msg_emty.html_safe
    end
  end
end
