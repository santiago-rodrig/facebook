require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'it has email as an attribute' do
    assert User.column_names.include? 'email'
  end

  test 'it has encrypted_password as an attribute' do
    assert User.column_names.include? 'encrypted_password'
  end

  test 'it has reset_password_token as an attribute' do
    assert User.column_names.include? 'reset_password_token'
  end

  test 'it has reset_password_set_at as an attribute' do
    assert User.column_names.include? 'reset_password_sent_at'
  end

  test 'it has remember_created_at as an attribute' do
    assert User.column_names.include? 'remember_created_at'
  end
end
