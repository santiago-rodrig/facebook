require 'rails_helper'

RSpec.feature 'UserCanRegisters', type: :feature do
  it 'registers a user' do
    users_count = User.count
    visit(new_user_registration_path)
    expect(page).to have_current_path(new_user_registration_path)
    fill_in('Email', with: 'bob@example.com')
    fill_in('First name', with: 'bob')
    fill_in('Last name', with: 'sinclair')
    fill_in('Password', with: 'secret')
    fill_in('Password confirmation', with: 'secret')
    click_button('Sign up')
    expect(User.count).to eq(users_count + 1)
  end
end
