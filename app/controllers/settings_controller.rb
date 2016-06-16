class SettingsController < ApplicationController
	before_filter :check_for_login

	def show
	end

	def change_subscription
	end

	def do_change_subscription
		render :change_subscription_confirm
	end

	def cancel_subscription
	end

	def do_cancel_subscription
		render :cancel_subscription_confirm
	end
end
