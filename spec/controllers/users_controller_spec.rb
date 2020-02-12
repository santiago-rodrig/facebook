require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do
    @bob = User.create(
      email: 'bob@example.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )

    @alice = User.create(
      email: 'alice@example.com',
      first_name: 'alice',
      last_name: 'smith',
      password: 'hidden',
      password_confirmation: 'hidden'
    )

    sign_in @bob
  end

  describe '#show' do
    it 'should get it' do
      get :show, params: { id: @bob.id }
      expect(response).to have_http_status(:success)
    end

    it 'assigns @user' do
      get :show, params: { id: @bob.id }
      expect(assigns(:user)).to eq(@bob)
    end
  end
end
