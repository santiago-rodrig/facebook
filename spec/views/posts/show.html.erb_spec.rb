require 'rails_helper'

RSpec.describe 'posts/show', type: :view do
  before do
    @user = User.create(
      email: 'bob@example.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )

    @jen = User.create(
      email: 'jen@example.com',
      first_name: 'jen',
      last_name: 'smith',
      password: 'secret',
      password_confirmation: 'secret'
    )

    sign_in(@user)

    @post = @user.posts.create(
      title: 'The post',
      content: 'Has content'
    )

    Comment.create([
      {
        commenter_id: @user.id,
        commented_post_id: @post.id,
        body: 'This post has content'
      },
      {
        commenter_id: @jen.id,
        commented_post_id: @post.id,
        body: 'Indeed it has'
      }
    ])

    @comments = @post.comments.order('created_at DESC')
    assign(:post, @post)
    assign(:comments, @comments)
  end

  context 'any user is watching the post' do
    it 'displays the title of the post' do
      render
      expect(rendered).to have_selector('h1')
      expect(rendered).to have_content(@post.title)

      expect(rendered).to(
        match(
          /.*<h1.*>.*#{@post.title}.*<\/h1>.*/mi
        )
      )
    end

    it 'displays the author name followed by the write time' do
      render

      expect(rendered).to(
        match(
          /.*<p.*>.*#{@user.full_name}.*#{@post.created_at}.*<\/p>.*/mi
        )
      )
    end

    it 'displays the content of the post' do
      render

      expect(rendered).to(
        match(
          /.*<p.*>.*#{@post.content}.*<\/p>.*/mi
        )
      )
    end

    it 'displays the image of the author linked to its profile' do
      render

      expect(rendered).to(
        have_selector(
          "a[href=\"#{user_path(@user)}\"] img[src=\"#{@user.image_url}\"]"
        )
      )
    end

    it 'displays the likes count for the post' do
      render

      expect(rendered).to(
        match(
          /.*<span.*class="badge".*>.*#{@post.likers.count}.*<\/span>.*/mi
        )
      )
    end

    it 'displays a form for commenting' do
      render
      expect(rendered).to have_selector('form')

      expect(rendered).to(
        match(
          /.*<label.*for="comment_body".*>.*What do you think\?.*<\/label>.*/mi
        )
      )

      expect(rendered).to have_selector('textarea#comment_body')

      expect(rendered).to(
        match(
          /.*<button.*type="submit".*>Comment<\/button>.*/mi
        )
      )
    end

    it 'displays the comments for the post' do
      render

      @comments.each do |c|
        expect(rendered).to(
          match(
            /.*<div.*class="panel-heading".*>.*#{c.commenter.full_name}.*#{c.created_at.utc}.*<\/div>/mi
          )
        )

        expect(rendered).to(
          match(
            /.*<div.*class="panel-body".*>.*#{c.body}.*<\/div>.*/mi
          )
        )
      end
    end

    context 'the user have not liked the post yet' do
      before do
        render
      end

      it 'displays a link to like the post' do
        url = like_post_path(post_id: @post.id)

        expect(rendered).to(
          have_selector(
            "a[href=\"#{url}\"]"
          )
        )
      end

      it 'displays a disabled link to dislike the post' do
        url = unlike_post_path(post_id: @post.id)

        expect(rendered).to(
          have_selector(
            "a[href=\"#{url}\"][disabled=\"disabled\"]"
          )
        )
      end
    end

    context 'the user already liked the post' do
      before do
        @user.liked_posts << @post
        render
      end

      it 'displays a disabled link to like the post' do
        url = like_post_path(post_id: @post.id)

        expect(rendered).to(
          have_selector(
            "a[href=\"#{url}\"][disabled=\"disabled\"]"
          )
        )
      end

      it 'displays a link to dislike the post' do
        url = unlike_post_path(post_id: @post.id)

        expect(rendered).to(
          have_selector(
            "a[href=\"#{url}\"]"
          )
        )
      end
    end
  end


  context 'logged in user is the author' do
    before do
      render
    end

    it 'displays a link to edit the post' do
      expect(rendered).to have_selector("a[href=\"#{edit_post_path(@post)}\"]")
    end

    it 'displays a link to delete the post' do
      expect(rendered).to(
        have_selector("a[href=\"#{post_path(@post)}\"][data-method=\"delete\"]")
      )
    end
  end

  context 'logged in user is not the author' do
    before do
      sign_out(@user)
      sign_in(@jen)
      render
    end

    it 'does not display a link to edit the post' do
      expect(rendered).not_to(
        have_selector("a[href=\"#{edit_post_path(@post)}\"]")
      )
    end

    it 'does not display a link to delete the post' do
      expect(rendered).not_to(
        have_selector(
          "a[href=\"#{post_path(@post)}\"][data-method=\"delete\"]"
        )
      )
    end
  end
end
