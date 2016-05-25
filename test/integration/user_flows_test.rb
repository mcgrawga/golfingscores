require 'test_helper'


class UserFlowsTest < ActionDispatch::IntegrationTest
  test "user can't see scores page unless logged in" do
    get scores_path
    assert_redirected_to root_path
  end

  test "user can see scores page after login" do
    get user_session_path
    assert_equal 200, status
    @david = User.create(email: "david@mail.com", password: Devise::Encryptor.digest(User, "helloworld"))
    post user_session_path, 'user[email]' => @david.email, 'user[password]' =>  @david.password
    follow_redirect!
    assert_equal 200, status
    assert_equal scores_path, path
    assert_select 'title', "Statgolf Scores"
    assert_select 'h1', "Scores"
  end



  test "user can't see course page unless logged in" do
    get courses_path
    assert_redirected_to root_path
  end

  test "user can see courses page after login" do
    get user_session_path
    assert_equal 200, status
    @david = User.create(email: "david@mail.com", password: Devise::Encryptor.digest(User, "helloworld"))
    post user_session_path, 'user[email]' => @david.email, 'user[password]' =>  @david.password
    follow_redirect!
    assert_equal 200, status
    assert_equal scores_path, path
    get courses_path
    assert_equal 200, status
    assert_select 'title', "Statgolf Golf Courses"
    assert_select 'h1', "Golf Courses"
  end

end
