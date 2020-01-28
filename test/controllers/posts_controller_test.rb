require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    post(
      user_registration_path,
      params: {
        user: {
          email: 'example@email.com',
          password: 'secret',
          password_confirmation: 'secret'
        }
      }
    )
    @user = User.last
  end

  test 'root should go to posts index' do
    get root_url
    assert_equal controller.controller_name, 'posts'
  end
end
