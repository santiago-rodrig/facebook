require 'rails_helper'

RSpec.describe FriendshipsHelper, type: :helper do
  let(:user) do
    User.create(
      email: 'bob@example.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )
  end

  let(:friend) do
    User.create(
      email: 'alice@example.com',
      first_name: 'alice',
      last_name: 'wonderland',
      password: 'hidden',
      password_confirmation: 'hidden'
    )
  end

  describe '#ask_friendship' do
    context 'users are the same' do
      it 'returns nil' do
        expect(helper.ask_friendship(user, user)).to be_nil
      end
    end

    context 'users are friends already' do
      before do
        user.friends << friend
        friend.accept_friend(user)
      end

      it 'returns nil' do
        expect(helper.ask_friendship(user, friend)).to be_nil
      end
    end

    context 'user already asked the friendship' do
      before do
        user.friends << friend
      end

      it 'returns nil' do
        expect(helper.ask_friendship(user, friend)).to be_nil
      end
    end

    context 'user has not asked the friendship yet' do
      it 'returns a button to ask the friendship' do
        ask_button = <<-BTN
  <div class="cleared pull-right">
    #{link_to 'Ask friendship', ask_friendship_path(friend_id: friend.id), method: :post, class: 'btn btn-primary'}
  </div>
        BTN

        expect(helper.ask_friendship(user, friend)).to(
          eq(
            ask_button.html_safe
          )
        )
      end
    end
  end

  describe '#put_requests' do
    context 'the user has no requesters' do
      let(:requests) { Friendship.requesters(user) }

      it 'returns an alert telling that the user has no friend requests' do
        msg_emty = <<-EMPTY
  <div class="col-sm-6 col-sm-offset-3">
    <div class="alert alert-info">
      You have no friend requests.
    </div>
  </div>
        EMPTY
        expect(helper.put_requests(requests)).to(
          eq(msg_emty.html_safe)
        )
      end
    end

    context 'the user has requesters' do
      before do
        friend.friends << user
      end

      let(:requests) { Friendship.requesters(user) }

      it 'renders the request for each requester partial' do
        expect(helper.put_requests(requests)).to(
          eq(
            render(partial: 'friendships/request', collection: requests)
          )
        )
      end
    end
  end
end
