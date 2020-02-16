require 'rails_helper'

RSpec.feature 'UserCanSignOuts', type: :feature do
  it 'signs out a user' do
    User.create(
      email: 'bob@example.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )

    visit(new_user_session_path)
    fill_in('Email', with: 'bob@example.com')
    fill_in('Password', with: 'secret')
    click_button('Log in')

    within('#account') do
      click_link('Account')
      click_link('Logout')
    end

    expect(page).to have_content('Signed out successfully')
  end
end
