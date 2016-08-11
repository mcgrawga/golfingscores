class TeesController < ApplicationController
	def new
		@course = Course.where("user_id = ? and id = ?", current_user.id, params[:course_id]).first
		@tee = Tee.new
	end

	def create
		log("Got to create in tees controller")
		@tee = Tee.new(tee_params)
		@tee.course_id = params[:course_id]
		if @tee.valid?
			log("Valid Tee")
			@tee.save
			log("Saved Tee")
			redirect_to edit_course_path(params[:course_id])
		else
			log("Invalid Tee")
			@course = Course.where("user_id = ? and id = ?", current_user.id, params[:course_id]).first
			render :new
		end
	end

	def edit
		@course = Course.where("user_id = ? and id = ?", current_user.id, params[:course_id]).first
		@tee = Tee.where("id = ? and course_id = ?", params[:id], params[:course_id]).first
	end

	def update
		@course = Course.where("user_id = ? and id = ?", current_user.id, params[:course_id]).first
		@tee = Tee.where("id = ? and course_id = ?", params[:id], @course.id).first
		if @tee.update(tee_params)
			redirect_to edit_course_path(params[:course_id])
		else
			render :edit
		end
	end

	def destroy
		@course = Course.where("user_id = ? and id = ?", current_user.id, params[:course_id]).first
		@tee = Tee.where("course_id = ? and id = ?", @course.id, params[:id]).first
		@tee.destroy
		redirect_to edit_course_path(params[:course_id])
	end

	def tee_params
    	params.require(:tee).permit(:name, :course_rating, :slope_rating,
    								:par_hole_1,
    								:par_hole_2,
    								:par_hole_3,
    								:par_hole_4,
    								:par_hole_5,
    								:par_hole_6,
    								:par_hole_7,
    								:par_hole_8,
    								:par_hole_9,
    								:par_hole_10,
    								:par_hole_11,
    								:par_hole_12,
    								:par_hole_13,
    								:par_hole_14,
    								:par_hole_15,
    								:par_hole_16,
    								:par_hole_17,
    								:par_hole_18,
    								:course_id
    								)
  	end
end
