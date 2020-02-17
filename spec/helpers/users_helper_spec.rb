require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  # This one plays the role of current_user
  let(:user) do
    User.create(
      email: 'bob@example.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )
  end

  let(:other_user) do
    User.create(
      email: 'alice@example.com',
      first_name: 'alice',
      last_name: 'wonderland',
      password: 'hidden',
      password_confirmation: 'hidden'
    )
  end

  context 'the user has no asked for the other_user friendship' do
    it 'returns \'Stranger\'' do
      expect(helper.relation_with(user, other_user)).to(
        eq('Stranger')
      )
    end
  end

  context 'the user asked for a friendship with other_user' do
    before do
      user.friends << other_user
    end

    it 'returns \'Pending friendship\'' do
      expect(helper.relation_with(user, other_user)).to(
        eq('Pending friendship')
      )
    end
  end

  context 'users are friends' do
    before do
      user.friends << other_user
      other_user.accept_friend(user)
    end

    it 'returns \'Friend\'' do
      expect(helper.relation_with(user, other_user)).to(
        eq('Friend')
      )
    end
  end

  context 'users are the same' do
    it 'returns \'Yourself\'' do
      expect(helper.relation_with(user, user)).to(
        eq('Yourself')
      )
    end
  end

  context 'the other_user asked for a friendship with user' do
    before do
      other_user.friends << user
    end

    it 'returns \'Pending friendship\'' do
      expect(helper.relation_with(user, other_user)).to(
        eq('Pending friendship')
      )
    end
  end
end
