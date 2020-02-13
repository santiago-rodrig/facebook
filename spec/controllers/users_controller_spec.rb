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
    before do
      get :show, params: { id: @bob.id }
    end

    it 'should get it' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns @user' do
      expect(assigns(:user)).to eq(@bob)
    end
  end

  describe '#edit' do
    before do
      get :edit, params: { id: @bob.id }
    end

    it 'should get it' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns @user' do
      expect(assigns(:user)).to eq(@bob)
    end
  end

  describe '#update' do
    before do
      patch(
        :update,
        params: {
          id: @bob.id,
          user: {
            first_name: 'stuart',
            last_name: 'james'
          }
        }
      )
    end

    it 'redirects' do
      expect(response).to have_http_status(:redirect)
    end

    it 'redirects to show' do
      expect(response).to redirect_to(user_path(@bob))
    end

    it 'sets flash[:success]' do
      expect(@controller.flash[:success]).to eq('User updated')
    end
  end

  describe '#index' do
    before do
      get :index
    end

    it 'gets' do
      expect(response).to have_http_status(:success)
    end

    it 'sets @users' do
      expect(assigns(:users)).not_to be_nil
    end
  end
end
