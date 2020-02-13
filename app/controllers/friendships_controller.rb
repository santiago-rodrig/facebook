class FriendshipsController < ApplicationController
  def friend_requests
    @requests = Friendship.requesters(current_user)
  end

  def accept_friend_request
    @friend = User.find(params[:friend_id])
    current_user.accept_friend(@friend)
    flash[:success] = "you and #{@friend.full_name} are now friends!"

    redirect_to friend_requests_path
  end

  def reject_friend_request
    @friend = User.find(params[:friend_id])
    current_user.reject_friend(@friend)
    flash[:info] = "you rejected #{@friend.full_name} friendship proposal"

    redirect_to friend_requests_path
  end

  def ask_friendship
    @friend = User.find(params[:friend_id])
    current_user.friends << @friend
    flash[:info] = "a friendship proposal has been sent to #{@friend.full_name}"

    redirect_to users_path
  end

  def friends_index
    @title = 'Your friends'
    @partial = 'friend'
    @users = current_user.real_friends.paginate(page: params[:page], per_page: 12)

    if params[:page]
      @first_half = @users.offset(12 * (params[:page].to_i - 1)).first(6)
      @second_half = @users.offset(12 * (params[:page].to_i - 1) + 6).first(6)
    else
      @first_half = @users.first(6)
      @second_half = @users.offset(6).first(6)
    end

    render template: 'shared/index'
  end

  def cancel_friendship
    @friend = User.find(params[:friend_id])
    current_user.cancel_friend(@friend)
    flash[:info] = "you and #{@friend.full_name} are no longer friends :("

    redirect_to friends_path
  end
end
