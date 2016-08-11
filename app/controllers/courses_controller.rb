class CoursesController < ApplicationController
	before_filter :check_for_login
	before_filter :check_for_subscription

	def index
		@courses = Course.where("user_id = ?", current_user.id).order("name ASC")
	end

	def new
		@course = Course.new
	end

	def create
		@course = Course.new(course_params)
		@course.user_id = current_user.id
		if @course.valid?
			@course.save
			redirect_to courses_path
		else
			render :new
		end
	end

	def edit
		@course = Course.where("user_id = ? and id = ?", current_user.id, params[:id]).first
		#@course = Course.new
	end

	def update
		@course = Course.where("user_id = ? and id = ?", current_user.id, params[:id]).first
		if @course.update(course_params)
			redirect_to courses_path
		else
			render :edit
		end
	end

	def destroy
		@course = Course.where("user_id = ? and id = ?", current_user.id, params[:id]).first
		@course.destroy
		redirect_to courses_path
	end

	def course_params
    	params.require(:course).permit(:name, :city, :state)
  	end
end
