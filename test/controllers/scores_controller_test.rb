require 'test_helper'

class ScoresControllerTest < ActionController::TestCase
	test "Should login and get the Scores page" do
		sign_in users(:user1)
		get :show
		assert_response :success
		assert_select 'title', "Statgolf Scores"
	end
end
