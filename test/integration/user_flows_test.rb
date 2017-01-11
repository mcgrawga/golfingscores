require 'test_helper'
require "stripe"

class UserFlowsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user1)
  end

  test "user can't see scores page unless logged in" do
    get scores_path
    assert_redirected_to root_path
  end

  test "user can see scores page after login" do
    post user_session_path, 'user[email]' => @user.email, 'user[password]' =>  'password'
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
    post user_session_path, 'user[email]' => @user.email, 'user[password]' =>  'password'
    follow_redirect!
    assert_equal 200, status
    assert_equal scores_path, path
    get courses_path
    assert_equal 200, status
    assert_select 'title', "Statgolf Golf Courses"
    assert_select 'h1', "Golf Courses"
  end



  test "user can't see settings page unless logged in" do
    get settings_path
    assert_redirected_to root_path
  end

  test "user can see settings page after login" do
    post user_session_path, 'user[email]' => @user.email, 'user[password]' =>  'password'
    follow_redirect!
    assert_equal 200, status
    assert_equal scores_path, path
    get settings_path
    assert_equal 200, status
    assert_select 'title', "Statgolf Settings"
    assert_select 'h1', "Settings"
  end

  test "user can change password after login" do
    post user_session_path, 'user[email]' => @user.email, 'user[password]' =>  'password'
    follow_redirect!
    assert_equal 200, status
    assert_equal scores_path, path

    original_pwd = @user.encrypted_password
    put '/users', 'user[email]' => @user.email, 'user[password]' =>  'somethingNew', 'user[password_confirmation]' =>  'somethingNew', 'user[current_password]' =>  'password'
    @user.reload
    new_pwd = @user.encrypted_password
    assert_not_equal original_pwd, new_pwd
  end

  test "user can change email after login" do
    post user_session_path, 'user[email]' => @user.email, 'user[password]' =>  'password'
    follow_redirect!
    assert_equal 200, status
    assert_equal scores_path, path

    original_email = @user.email
    put '/users', 'user[email]' => 'ronjohn@surfshop.com', 'user[current_password]' =>  'password'
    @user.reload
    new_email = @user.email
    assert_not_equal original_email, new_email
  end

  test "Should register a new user, upgrade their plan, cancel their subscription plan then renew their plan" do 
    #
    #  Register new user
    #
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    token = Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 5,
        :exp_year => 2017,
        :cvc => "314"
      },
    )
    post '/users', :user => { :email => 'something@gmail.com', :password =>  'password', :password_confirmation =>  'password' },
            :stripeToken => token.id, :plan_name => 'Statgolf Duffer'
    new_user = User.find_by_email('something@gmail.com')
    assert_not_nil new_user

    #
    #  Upgrade the plan
    #
    post '/settings/change_subscription?plan_name=Statgolf+Amateur'
    new_user.reload
    assert_equal 'Statgolf Amateur', new_user.stripe_plan

    #
    #  Cancel Subscription
    #
    post '/settings/cancel_subscription?plan_name=Statgolf+Amateur'
    new_user.reload
    assert_nil new_user.stripe_customer_id

    #
    #  Renew Subscription
    #
    token = Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 5,
        :exp_year => 2017,
        :cvc => "314"
      },
    )
    post '/settings/renew_subscription', :stripeToken => token.id
    new_user.reload
    assert_not_nil new_user.stripe_customer_id
  end

end
