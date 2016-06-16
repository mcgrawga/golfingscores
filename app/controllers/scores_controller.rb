class ScoresController < ApplicationController
	before_filter :check_for_login
	before_filter :check_for_subscription

	def show
	end
end
