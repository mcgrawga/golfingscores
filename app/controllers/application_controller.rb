class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
  	scores_path
  end

  def check_for_login
	redirect_to root_path unless user_signed_in?
   end

   def check_for_subscription
   	redirect_to settings_renew_subscription_path if current_user.stripe_customer_id.nil?
   end
end
