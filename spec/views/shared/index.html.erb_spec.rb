require 'rails_helper'

RSpec.describe 'shared/index', type: :view do
  describe 'users' do
    before do
      assign(:title, 'All users')
      @users = User.paginate(page: params[:page], per_page: 12)
      @first_half = @users.first(6)
      @second_half = @users.offset(6).first(6)
      @combined = @first_half + @second_half
      assign(:users, @users)
      assign(:partial, 'users/user')
      assign(:first_half, @users.first(6))
      assign(:second_half, @users.offset(6).first(6))

      render
    end

    it 'displays all user names' do
      @combined.each do |user|
        expect(rendered).to(
          have_selector(
            "dt[value=\"Name\"] + dd[value=\"user.full_name\"]"
          )
        )
      end
    end

    it 'displays an image of the user linked to its profile' do
      @combined.each do |user|
        expect(rendered).to(
          have_selector(
            "a[href=\"#{user_path(user)}\"] img[src=\"#{user.image_url}\"]"
          )
        )
      end
    end

    it 'displays the total likes that the user has received' do
      @combined.each do |user|
        expect(rendered).to(
          have_selector(
            "dt[value=\"Likes\"] + dd[value=\"#{user.total_likes}\"]"
          )
        )
      end
    end

    it 'displays the total number of posts of each user' do
      @combined.each do |user|
        expect(rendered).to(
          have_selector(
            "dt[value=\"Posts\"] dd[value=\"#{user.posts.count}\"]"
          )
        )
      end
    end
  end

  describe 'friends' do
    before do
      @user = User.create(
        email: 'bob@example.com',
        first_name: 'bob',
        last_name: 'sinclair',
        password: 'secret',
        password_confirmation: 'secret'
      )

      @friend = User.create(
        email: 'alice@example.gov',
        first_name: 'alice',
        last_name: 'wonderland',
        password: 'rabbit',
        password_confirmation: 'rabbit'
      )

      sign_in(@user)
      @title = 'Your friends'
      @partial = 'friendships/friend'
      assign(:title, @title)
      assign(:partial, @partial)
    end

    context 'the user has no friends' do
      before do
        @users = @controller.current_user.
        real_friends.
        paginate(
          page: @controller.params[:page], per_page: 12
        )

        @first_half = @users.first(6)
        @second_half = @users.offset(6).first(6)
        @combined = @first_half + @second_half
        assign(:users, @users)
        assign(:first_half, @first_half)
        assign(:second_half, @second_half)
        render
      end

      it 'displays an alert telling that the user has no friends' do
        expect(rendered).to(
          match(
            /.*<div.*class="(alert)|(alert\-info)".*>.*You have no friends! :\(,.*<\/div>/mi
          )
        )
      end

      it 'does not display any user image linked to its profile' do
        @combined.each do |f|
          expect(rendered).not_to(
            have_selector(
              "a[href=\"#{user_path(f)}\"] img[src=\"#{f.image_url}\"]"
            )
          )
        end
      end

      it 'does not display any use information' do
        expect(rendered).not_to have_selector('dl dt, dl dd')

        @combined.each do |f|
          expect(rendered).not_to(
            match(
              /.*<dt>Name<\/dt>.*<dd>#{f.full_name}<\/dd>.*/mi
            )
          )

          expect(rendered).not_to(
            match(
              /.*<dt>Posts<\/dt>.*<dd>#{f.posts.count}<\/dd>.*/mi
            )
          )

          expect(rendered).not_to(
            match(
              /.*<dt>Likes<\/dt>.*<dd>#{f.total_likes}<\/dd>.*/mi
            )
          )
        end
      end

      it 'does not display cancel_friendship links' do
        @combined.each do |f|
          expect(
            rendered
          ).not_to(
            have_selector(
              "a[href=\"#{cancel_friendship_path(friend_id: f.id)}\"][data-method=\"delete\"]"
            )
          )
        end
      end
    end

    context 'the user has friends' do
      before do
        @user.friends << @friend
        @friend.accept_friend(@user)
        @users = @controller.current_user.
        real_friends.
        paginate(
          page: @controller.params[:page], per_page: 12
        )

        @first_half = @users.first(6)
        @second_half = @users.offset(6).first(6)
        @combined = @first_half + @second_half
        assign(:users, @users)
        assign(:first_half, @first_half)
        assign(:second_half, @second_half)
        render
      end

      it 'does not display an alert telling that the user has no friends' do
        expect(rendered).not_to(
          match(
            /.*<div.*class="(alert)|(alert\-info)".*>.*You have no friends! :\(,.*<\/div>/mi
          )
        )
      end

      it 'display friends image linked to their profile' do
        @combined.each do |f|
          expect(rendered).to(
            have_selector(
              "a[href=\"#{user_path(f)}\"] img[src=\"#{f.image_url}\"]"
            )
          )
        end
      end

      it 'displays each friend information' do
        expect(rendered).to have_selector('dl dt, dl dd')

        @combined.each do |f|
          expect(rendered).to(
            match(
              /.*<dt>Name<\/dt>.*<dd>#{f.full_name}<\/dd>.*/mi
            )
          )

          expect(rendered).to(
            match(
              /.*<dt>Posts<\/dt>.*<dd>#{f.posts.count}<\/dd>.*/mi
            )
          )

          expect(rendered).to(
            match(
              /.*<dt>Likes<\/dt>.*<dd>#{f.total_likes}<\/dd>.*/mi
            )
          )
        end
      end

      it 'displays cancel_friendship link for each friend' do
        @combined.each do |f|
          expect(
            rendered
          ).to(
            have_selector(
              "a[href=\"#{cancel_friendship_path(friend_id: f.id)}\"][data-method=\"delete\"]"
            )
          )
        end
      end
    end
  end
end
