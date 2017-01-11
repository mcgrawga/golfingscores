require 'test_helper'
require "stripe"

class UsersRegistrationsControllerTest < ActionController::TestCase
	def setup
    	@controller = Users::RegistrationsController.new
  	end
  	test "Should get registration page with stripe fields" do
  		@request.env["devise.mapping"] = Devise.mappings[:user]
		get :new, plan_name: 'Statgolf Duffer'
		assert_response :success
		assert_select 'title', "Statgolf Sign Up"
		# Make sure stipe fields are present
		assert_select("label[for='credit_card_number']")
		assert_select("label[for='expiration_date']")
		assert_select("label[for='csv']")
		#assert_select 'title', "Statgolf Golf Courses"
	end

	test "Should register a new user and save stripe customer id" do
  		@request.env["devise.mapping"] = Devise.mappings[:user]
		Stripe.api_key = ENV['STRIPE_SECRET_KEY']

		token = Stripe::Token.create(
		  :card => {
		    :number => "4242424242424242",
		    :exp_month => 5,
		    :exp_year => 2017,
		    :cvc => "314"
		  },
		)

		post :create, :user => { :email => 'something@gmail.com', :password =>  'password', :password_confirmation =>  'password' },
						:stripeToken => token.id, :plan_name => 'Statgolf Duffer'

	    new_user = User.find_by_email('something@gmail.com')
	    assert_not_nil new_user
	end
end