require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  describe '#destroy' do
    before do
      @user = User.create(
        email: 'bob@example.com',
        first_name: 'bob',
        last_name: 'sinclair',
        password: 'secret',
        password_confirmation: 'secret'
      )

      sign_in(@user)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      delete(:destroy)
    end

    it 'sets flash[:notice]' do
      expect(@controller.flash[:notice]).not_to be_nil
    end

    it 'redirects to #new' do
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
