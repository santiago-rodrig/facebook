require 'rails_helper'

RSpec.describe 'friendships/friend_requests', type: :view do
  before do
    @user = User.create(
      email: 'bob@example.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )

    @friend = User.create(
      email: 'alice@example.com',
      first_name: 'alice',
      last_name: 'wonderland',
      password: 'rabbit',
      password_confirmation: 'rabbit'
    )

    sign_in(@user)
    @requests = Friendship.requesters(@controller.current_user)
    assign(:requests, @requests)
  end

  context 'the user has no friend requests' do
    before do
      render
    end

    it 'displays "Your friend requests" as a h1' do
      expect(rendered).to(
        match(
          /.*<h1.*>Your friend requests<\/h1>.*/mi
        )
      )
    end

    it 'does not display a image link to each requester profile' do
      @requests.each do |r|
        expect(rendered).not_to(
          have_selector(
            "a[href=\"#{user_path(r.user)}\"] img[src=\"#{r.user.image_url}\"]"
          )
        )
      end
    end

    it 'does not display the name of any user' do
      expect(rendered).not_to have_selector('dl dt, dl dd')

      @requests.each do |r|
        expect(rendered).not_to(
          match(
            /.*<dt>Name<\/dt>.*<dd>#{r.user.full_name}<\/dd>.*/mi
          )
        )
      end
    end

    it 'does not display a link to accept the friend request' do
      @requests.each do |r|
        expect(rendered).not_to(
          have_selector(
            "a[href=\"#{accept_friend_request_path(friend_id: r.user.id)}\"][data-method=\"post\"]"
          )
        )
      end
    end

    it 'does not display a link to reject the friend request' do
      @requests.each do |r|
        expect(rendered).not_to(
          have_selector(
            "a[href=\"#{reject_friend_request_path(friend_id: r.user.id)}\"][data-method=\"delete\"]"
          )
        )
      end
    end

    it 'displays an alert telling that the user has no friend requests' do
      expect(rendered).to(
        match(
          /.*<div.*class="(alert)|(alert\-info)".*>.*You have no friend requests\..*<\/div>.*/mi
        )
      )
    end
  end

  context 'the user has friend requests' do
    before do
      @friend.friends << @user
      render
    end

    it 'displays "Your friend requests" as a h1' do
      expect(rendered).to(
        match(
          /.*<h1.*>Your friend requests<\/h1>.*/mi
        )
      )
    end

    it 'displays a image link to each requester profile' do
      @requests.each do |r|
        expect(rendered).to(
          have_selector(
            "a[href=\"#{user_path(r.user)}\"] img[src=\"#{r.user.image_url}\"]"
          )
        )
      end
    end

    it 'displays the name of any user' do
      expect(rendered).to have_selector('dl dt, dl dd')

      @requests.each do |r|
        expect(rendered).to(
          match(
            /.*<dt>Name<\/dt>.*<dd>#{r.user.full_name}<\/dd>.*/mi
          )
        )
      end
    end

    it 'displays a link to accept the friend request' do
      @requests.each do |r|
        expect(rendered).to(
          have_selector(
            "a[href=\"#{accept_friend_request_path(friend_id: r.user.id)}\"][data-method=\"post\"]"
          )
        )
      end
    end

    it 'displays a link to reject the friend request' do
      @requests.each do |r|
        expect(rendered).to(
          have_selector(
            "a[href=\"#{reject_friend_request_path(friend_id: r.user.id)}\"][data-method=\"delete\"]"
          )
        )
      end
    end

    it 'does not display an alert telling that the user has no friend requests' do
      expect(rendered).not_to(
        match(
          /.*<div.*class="(alert)|(alert\-info)".*>.*You have no friºend requests\..*<\/div>.*/mi
        )
      )
    end
  end
end
