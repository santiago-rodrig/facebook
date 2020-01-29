require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test 'should have title attribute' do
    assert_includes Post.column_names, 'title'
  end

  test 'should have content attribute' do
    assert_includes Post.column_names, 'content'
  end

  test 'should belong to an author' do
    assert_respond_to Post.new, :author
  end
end
