class SettingsController < ApplicationController
	before_filter :check_for_login
	before_filter :check_for_subscription, :except => [:renew_subscription, :do_renew_subscription]

	def show
	end

	def change_subscription
		Stripe.api_key = ENV['STRIPE_SECRET_KEY']
		stripeCustomer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
		subscription = Stripe::Subscription.retrieve(stripeCustomer.subscriptions.first.id)
		@current_stripe_plan = subscription.plan.id
		@low_stripe_plan = ""
		@medium_stripe_plan = ""
		@high_stripe_plan = ""
		@low_stripe_plan_price = ""
		@medium_stripe_plan_price = ""
		@high_stripe_plan_price = ""
		@month_or_year = ""
		if (@current_stripe_plan == "Golfingscores Amateur Yearly 1" || @current_stripe_plan == "Golfingscores Club Yearly 3" || @current_stripe_plan == "Golfingscores Pro Yearly 5")
			@low_stripe_plan = "Golfingscores Amateur Yearly 1"
			@medium_stripe_plan = "Golfingscores Club Yearly 3"
			@high_stripe_plan = "Golfingscores Pro Yearly 5"
			@low_stripe_plan_price = "1"
			@medium_stripe_plan_price = "3"
			@high_stripe_plan_price = "5"
			@month_or_year = "year"
		elsif (@current_stripe_plan == "Golfingscores Amateur Yearly Minus 10" || @current_stripe_plan == "Golfingscores Club Yearly Minus 10" || @current_stripe_plan == "Golfingscores Pro Yearly Minus 10")
			@low_stripe_plan = "Golfingscores Amateur Yearly Minus 10"
			@medium_stripe_plan = "Golfingscores Club Yearly Minus 10"
			@high_stripe_plan = "Golfingscores Pro Yearly Minus 10"
			@low_stripe_plan_price = "7"
			@medium_stripe_plan_price = "11"
			@high_stripe_plan_price = "15"
			@month_or_year = "year"
		end
		log(@current_stripe_plan)
	end

	def do_change_subscription
		Stripe.api_key = ENV['STRIPE_SECRET_KEY']
		stripeCustomer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
		subscription = Stripe::Subscription.retrieve(stripeCustomer.subscriptions.first.id)
		subscription.plan = params[:plan_name]
		subscription.save
		current_user.stripe_plan = params[:plan_name]
		current_user.save
		render :change_subscription_confirm
	end

	def cancel_subscription
	end

	def do_cancel_subscription
		Stripe.api_key = ENV['STRIPE_SECRET_KEY']
		stripeCustomer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
		subscription = Stripe::Subscription.retrieve(stripeCustomer.subscriptions.first.id)
		subscription.delete
		current_user.stripe_customer_id = nil
		current_user.save
		render :cancel_subscription_confirm
	end

	def renew_subscription
	end
	def do_renew_subscription
		token = params[:stripeToken]
        # Create a Customer and a subsctiption
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']
        customer = Stripe::Customer.create(
          :source => params[:stripeToken],
          :plan => current_user.stripe_plan,
          :email => current_user.email
        )
        # Add stripe customer id to customer in database
        current_user.stripe_customer_id = customer.id
        current_user.save
		render :renew_subscription_confirm
	end
end
