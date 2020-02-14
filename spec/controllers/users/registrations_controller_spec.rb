require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  describe '#create' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @user_count = User.count

      post(
        :create,
        params: {
          user: {
            email: 'bob@example.com',
            first_name: 'bob',
            last_name: 'sinclair',
            password: 'secret',
            password_confirmation: 'secret'
          }
        }
      )
    end

    it 'creates a User' do
      expect(User.count).to eq(@user_count + 1)
    end

    it 'sets all the attributes properly' do
      expect(@controller.current_user.first_name).to eq('bob')
      expect(@controller.current_user.last_name).to eq('sinclair')
      expect(@controller.current_user.email).to eq('bob@example.com')
    end
  end
end
