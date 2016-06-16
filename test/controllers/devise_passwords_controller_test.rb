require 'test_helper'
require "stripe"

class DevisePasswordsControllerTest < ActionController::TestCase
	def setup
    	@controller = Devise::PasswordsController.new
  	end
  	test "Should send a password reset email to user" do
  		@request.env["devise.mapping"] = Devise.mappings[:user]
		post :create, :user => { :email => 'user1@statgolf.com'}
	    user = User.find_by_email('user1@statgolf.com')
	    assert_not_nil user
	    assert_not_nil user.reset_password_token
	end
end