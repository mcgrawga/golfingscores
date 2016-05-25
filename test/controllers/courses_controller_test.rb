require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  test "Should login and get the Courses page" do
		sign_in users(:user1)
		get :show
		assert_response :success
		assert_select 'title', "Statgolf Courses"
	end
end
