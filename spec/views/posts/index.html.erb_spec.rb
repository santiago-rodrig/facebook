require 'rails_helper'

RSpec.describe 'posts/index', type: :view do
  before do
    @user = User.create(
      email: 'bob@example.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )

    @user.posts.create([
      { title: 'Post 1', content: 'Stuffs' },
      { title: 'Post 2', content: 'Stuffs' }
    ])

    @jen = User.create(
      email: 'jen@example.com',
      first_name: 'jen',
      last_name: 'stewarts',
      password: 'hidden',
      password_confirmation: 'hidden'
    )

    @user.friends << @jen
    @jen.accept_friend(@user)

    @jen.posts.create([
      { title: 'Jen wrote this', content: 'Whatevs' },
      { title: 'Jen also wrote this', content: 'Blurp' }
    ])

    sign_in(@user)

    @posts = @user.feed.recents.
      paginate(page: @controller.params[:page], per_page: 10)

    @first_half = @posts.first(5)
    @second_half = @posts.offset(5).first(5)
    @combined = @first_half + @second_half
    @title = 'Your feed'
    assign(:posts, @posts)
    assign(:first_half, @first_half)
    assign(:second_half, @second_half)
    assign(:title, @title)
  end

  it 'displays "Your feed" as a heading' do
    render
    expect(rendered).to have_selector('h1')
    expect(rendered).to have_content('Your feed')
    expect(rendered).to(
      match(
        /.*<h1.*>.*Your feed.*<\/h1>.*/mi
      )
    )
  end

  context 'no posts to show' do
    before do
      Post.delete_all
      render
    end

    it 'displays an alert' do
      expect(rendered).to have_selector('div.alert.alert-info')
      expect(rendered).to have_content('Your feed is empty!')

      expect(rendered).to(
        have_selector(
          "div.alert.alert-info a[href=\"#{users_path}\"]"
        )
      )

      expect(rendered).to(
        have_selector(
          "div.alert.alert-info a[href=\"#{new_post_path}\"]"
        )
      )

      expect(rendered).to(
        match(
          /.*<div.*class=\"(alert)|(alert\-info)\".*>.*Your feed is empty!.*<\/div>.*/mi
        )
      )
    end
  end


  context 'posts to show' do
    it 'displays the posts in the feed of the user' do
      render

      @combined.each do |p|
        expect(rendered).to(
          match(
            /.*<div.*class=\"well\".*>.*#{p.title}.*#{p.content}.*<\/div>.*/mi
          )
        )

        expect(rendered).to(
          have_selector(
            "a[href=\"#{user_path(p.author)}\"] img[src=\"#{p.author.image_url}?s=50\"]"
          )
        )

        expect(rendered).to(
          have_selector(
            "a[href=\"#{post_path(p)}\"] h3"
          )
        )

        expect(rendered).to(
          match(
            /.*<span.*class=\"badge\".*>.*#{p.likers.count}.*<\/span>.*/mi
          )
        )
      end
    end
  end
end
