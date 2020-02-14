require 'rails_helper'

RSpec.describe Post, type: :model do
  describe '::recents' do
    it 'returns the collection of posts ordered from newest to oldest' do
      user = User.create(
        email: 'bob@example.com',
        first_name: 'bob',
        last_name: 'sinclair',
        password: 'secret',
        password_confirmation: 'secret'
      )

      user.posts.create([
        {
          title: 'This post 1',
          content: 'Is original'
        },
        {
          title: 'This post 2',
          content: 'Is also original'
        },
        {
          title: 'This post 3',
          content: 'Original as the others'
        }
      ])

      ordered = Post.all.order('created_at DESC')
      expect(Post.count).to eq(3)
      expect(Post.recents).to eq(ordered)
    end
  end
end
