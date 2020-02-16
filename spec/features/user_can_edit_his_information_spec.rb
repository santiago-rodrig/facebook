require 'rails_helper'

RSpec.feature "UserCanEditHisInformations", type: :feature do
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

  it 'edits his information' do
    visit(user_path(user))
    expect(page).to have_content('Edit user information')
    click_link('Edit user information')
    expect(page).to have_current_path(edit_user_path(user))
    expect(page).to have_content('Edit user information')
    fill_in('First name', with: 'leonard')
    fill_in('Last name', with: 'miller')
    select('male', from: 'Gender')
    fill_in('Phone', with: '+584242184009')
    fill_in('Birthday', with: '11291996')
    click_button('Update user information')
    expect(page).to have_current_path(user_path(user))
    expect(page).to have_content('User updated')
    user.reload
    expect(user.first_name).to eq('leonard')
    expect(user.last_name).to eq('miller')
    expect(user.gender).to eq('male')
    expect(user.phone).to eq('+584242184009')
    expect(user.birthday).to eq(Date.new(1996, 11, 29))
  end
end
