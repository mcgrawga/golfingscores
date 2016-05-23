require 'test_helper'

class StaticpagesControllerTest < ActionController::TestCase
	test "Should get the Index page" do
		get :index
		assert_response :success
		assert_select 'title', "Statgolf"
	end

	test "Should get the About page" do
		get :about
		assert_response :success
		assert_select 'title', "Statgolf About"
	end
end
