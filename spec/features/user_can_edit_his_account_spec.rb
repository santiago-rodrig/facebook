require 'rails_helper'

RSpec.feature "UserCanEditHisAccounts", type: :feature do
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

  it 'edits his account' do
    old_password = user.encrypted_password
    visit(user_path(user))

    expect(page).to have_selector(
      "a[href=\"#{edit_user_registration_path}\"]"
    )

    expect(page).to have_content(
      'Edit account (email and password)'
    )

    click_link('Edit account (email and password)')
    expect(page).to have_content('Edit account')
    fill_in('Email', with: 'bob@example.org')
    fill_in('Password', with: 'supersecret')
    fill_in('Password confirmation', with: 'supersecret')
    fill_in('Current password', with: 'secret')
    click_button('Update account')
    expect(page).to have_current_path(root_path)
    expect(page).to have_content('Your account has been updated successfully')
    user.reload
    expect(user.email).to eq('bob@example.org')
    expect(user.encrypted_password).not_to eq(old_password)
  end
end
