require 'rails_helper'

RSpec.feature 'UserCanCancelHisAccounts', type: :feature do
  let(:user) do
    User.create(
      email: 'bob@example.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )
  end

  before do
    sign_in(user)
  end

  it 'cancels his account' do
    visit(user_path(user))
    click_link('Edit account (email and password)')
    expect(page).to have_content('Cancel my account')

    accept_confirm do
      click_button('Cancel my account')
    end

    expect(page).to have_current_path(new_user_session_path)
    expect(User.all).not_to include(user)
  end
end
