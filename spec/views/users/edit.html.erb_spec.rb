require 'rails_helper'

RSpec.describe 'users/edit', type: :view do
  before do
    @user = User.create(
      email: 'bob@example.com',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )

    assign(:user, @user)
    render
  end

  it 'displays a form' do
    expect(rendered).to have_selector('form')
  end

  it 'displays a text input for the user first name' do
    expect(rendered).to have_selector('input[type="text"]#user_first_name')
  end

  it 'displays a text input for the user last name' do
    expect(rendered).to have_selector('input[type="text"]#user_last_name')
  end

  it 'displays a select to pick the gender' do
    expect(rendered).to have_selector('select#user_gender')
  end

  it 'displays a tel field for the phone' do
    expect(rendered).to have_selector('input[type="tel"]#user_phone')
  end

  it 'displays a date field for the birthday' do
    expect(rendered).to have_selector('input[type="date"]#user_birthday')
  end

  it 'displays a submit button' do
    expect(rendered).to have_selector('button[type="submit"]')
  end
end
