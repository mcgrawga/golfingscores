require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
	test "Should login and get the Settings page" do
		sign_in users(:user1)
		get :show
		assert_response :success
		assert_select 'title', "Statgolf Settings"
	end
end
