class ScoresController < ApplicationController
	before_filter :check_for_login
	before_filter :check_for_subscription

	def index
	end

	def new
		@score = Score.new
		@courses = Course.where("user_id = ?", current_user.id).order("name ASC")
	end

	def get_tees_for_course
		@tees = Tee.where("course_id = ?", params[:id]).order("name ASC")
		render json: @tees
	end

	def get_tee
		@tee = Tee.find(params[:id])
		render json: @tee
	end
end
