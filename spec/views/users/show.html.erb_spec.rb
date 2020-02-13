require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  before do
    @user = User.create(
      email: 'bob@example.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )

    @posts = @user.posts.recents.paginate(page: params[:page], per_page: 10)
    @first_half = @posts.first(5)
    @second_half = @posts.offset(5).first(5)
    @combined = @first_half + @second_half
    sign_in(@user)
    assign(:user, @user)
    assign(:posts, @posts)
    assign(:first_half, @first_half)
    assign(:second_half, @second_half)
  end

  it 'displays an alert if the user have no posts' do
    render
    expect(rendered).to have_selector('div.alert.alert-info')
    expect(rendered).to have_content('You have no posts')

    expect(rendered).to(
      match(
        /.*<div class="alert alert\-info".*>.*You have no posts.*<\/div>.*/mi
      )
    )
  end

  it 'displays "Your Profile" as a heading if the current user is the same' do
    render
    expect(rendered).to have_selector('h1')
    expect(rendered).to have_content('Your Profile')
    expect(rendered).to(
      match(
        /.*<h1.*>.*Your Profile.*<\/h1>.*/mi
      )
    )
  end

  it 'displays "USER_NAME Profile" as a heading if the current user is not the same' do
    sign_out(@user)

    @jen = User.create(
      email: 'jen@example.com',
      first_name: 'jen',
      last_name: 'stevens',
      password: 'hidden',
      password_confirmation: 'hidden'
    )

    sign_in(@jen)
    render
    expect(rendered).to have_selector('h1')
    expect(rendered).to have_content("#{@user.full_name} Profile")
    expect(rendered).to(
      match(
        /.*<h1.*>.*#{@user.full_name} Profile.*<\/h1>.*/mi
      )
    )
  end

  it 'displays the user info in a list' do
    render
    expect(rendered).to have_selector('dl.user-info')
    expect(rendered).to have_selector('dl.user-info dt')
    expect(rendered).to have_selector('dl.user-info dd')

    expect(rendered).to(
      match(
        /.*<dt>.*Phone.*<\/dt>.*<dd>.*#{@user.phone}.*<\/dd>.*/mi
      )
    )

    expect(rendered).to(
      match(
        /.*<dt>.*Email.*<\/dt>.*<dd>.*#{@user.email}.*<\/dd>.*/mi
      )
    )

    expect(rendered).to(
      match(
        /.*<dt>.*First name.*<\/dt>.*<dd>.*#{@user.first_name}.*<\/dd>.*/mi
      )
    )

    expect(rendered).to(
      match(
        /.*<dt>.*Last name.*<\/dt>.*<dd>.*#{@user.last_name}.*<\/dd>.*/mi
      )
    )

    expect(rendered).to(
      match(
        /.*<dt>.*Birthday.*<\/dt>.*<dd>.*#{@user.birthday}.*<\/dd>.*/mi
      )
    )

    expect(rendered).to(
      match(
        /.*<dt>.*Gender.*<\/dt>.*<dd>.*#{@user.gender}.*<\/dd>.*/mi
      )
    )
  end

  it 'displays a link to edit the registration data if the current user is the same' do
    render
    expect(rendered).to have_selector("a[href=\"#{edit_user_registration_path}\"]")
  end

  it 'does not display a link to edit the registration data if the current user is not the same' do
    sign_out(@user)

    @jen = User.create(
      email: 'jen@example.com',
      first_name: 'jen',
      last_name: 'stevens',
      password: 'hidden',
      password_confirmation: 'hidden'
    )

    sign_in(@jen)
    render
    expect(rendered).not_to have_selector("a[href=\"#{edit_user_registration_path}\"]")
  end

  it 'displays a link to edit user\'s optional data if the current user is the same' do
    render
    expect(rendered).to have_selector("a[href=\"#{edit_user_path(@user)}\"]")
  end

  it 'does not display a link to edit the user optional data if the current user is not the same' do
    sign_out(@user)

    @jen = User.create(
      email: 'jen@example.com',
      first_name: 'jen',
      last_name: 'stevens',
      password: 'hidden',
      password_confirmation: 'hidden'
    )

    sign_in(@jen)
    render
    expect(rendered).not_to have_selector("a[href=\"#{edit_user_path(@user)}\"]")
  end

  it 'displays all the user posts' do
    render

    @combined.each do |p|
      expect(rendered).to(
        match(
          /.*<h3.*>.*#{p.title}.*<\/h3>.*/mi
        )
      )

      expect(rendered).to(
        have_selector(
          "img[src=\"#{p.author.image_url}?s=50\"]"
        )
      )

      expect(rendered).to(
        have_selector(
          "a[href=\"#{post_path(p)}\"]"
        )
      )

      expect(rendered).to(
        match(
          /.*#{p.content[0...300]}.*/mi
        )
      )
    end
  end

  it 'displays the total number of posts of the user' do
    render

    expect(rendered).to(
      match(
        /.*<dt>.*Posts.*<\/dt>.*<dd>.*#{@user.posts.count}.*<\/dd>.*/mi
      )
    )
  end

  it 'displays the accumulated likes for the user posts' do
    render

    expect(rendered).to(
      match(
        /.*<dt>.*Likes.*<\/dt>.*<dd>.*#{@user.total_likes}.*<\/dd>.*/mi
      )
    )
  end
end
