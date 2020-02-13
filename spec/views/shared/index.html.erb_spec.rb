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
      assign(:partial, 'user')
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
end
