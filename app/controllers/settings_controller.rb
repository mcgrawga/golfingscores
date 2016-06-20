class SettingsController < ApplicationController
	before_filter :check_for_login
	before_filter :check_for_subscription, :except => [:renew_subscription, :do_renew_subscription]

	def show
	end

	def change_subscription
		Stripe.api_key = ENV['SECRET_KEY']
		stripeCustomer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
		subscription = Stripe::Subscription.retrieve(stripeCustomer.subscriptions.first.id)
		@current_stripe_plan = subscription.plan.id
	end

	def do_change_subscription
		log("Changing to this plan:  " + params[:plan_name])
		Stripe.api_key = ENV['SECRET_KEY']
		stripeCustomer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
		subscription = Stripe::Subscription.retrieve(stripeCustomer.subscriptions.first.id)
		subscription.plan = params[:plan_name]
		subscription.save
		render :change_subscription_confirm
	end

	def cancel_subscription
	end

	def do_cancel_subscription
		log("Stripe secret key: " + ENV['SECRET_KEY'])
		Stripe.api_key = ENV['SECRET_KEY']
		log("Logged in user stripe customer id: " + current_user.stripe_customer_id)
		stripeCustomer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
		log("stripeCustomer.id: " + stripeCustomer.id)
		log("stripeCustomer.subscriptions.first.id: " + stripeCustomer.subscriptions.first.id)
		subscription = Stripe::Subscription.retrieve(stripeCustomer.subscriptions.first.id)
		subscription.delete
		log("Deleted subscription")
		current_user.stripe_customer_id = nil
		current_user.save
		log("Deleted stripe_customer_id for the current user")
		render :cancel_subscription_confirm
	end

	def renew_subscription
	end
	def do_renew_subscription
		token = params[:stripeToken]
		log("stripe token: " + token)
        # Create a Customer and a subsctiption
        Stripe.api_key = ENV['SECRET_KEY']
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
