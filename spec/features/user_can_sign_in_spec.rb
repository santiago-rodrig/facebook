require 'rails_helper'

RSpec.feature 'UserCanSignIns', type: :feature do
  it 'signs in a user' do
    User.create(
      email: 'bob@example.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )

    visit(new_user_session_path)
    expect(page).to have_current_path(new_user_session_path)
    fill_in('Email', with: 'bob@example.com')
    fill_in('Password', with: 'secret')
    click_button('Log in')
    expect(page).to have_current_path(root_path)
    expect(page).to have_content('Signed in successfully')
  end
end
