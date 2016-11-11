class ScoresController < ApplicationController
	before_filter :check_for_login
	before_filter :check_for_subscription

	def index
		@scores = Score.joins("INNER JOIN tees ON tees.id = scores.tee_id INNER JOIN courses ON courses.id = tees.course_id and courses.user_id = %s" % current_user.id.to_s)
		log("Userid:  %s" %  current_user.id.to_s)
	end

	def new
		@score = Score.new
		@courses = Course.where("user_id = ?", current_user.id).order("name ASC")
	end

	def create
		log("Date played:  " + score_params[:date_played])
		@score = Score.new(score_params)
		@score.date_played = DateTime.strptime(score_params[:date_played], "%m/%d/%Y")
		log("Date played from object:  " + @score.date_played.to_s)
		if @score.valid?
			@score.save
			redirect_to scores_path
		else
			render :new
		end
	end

	def get_tees_for_course
		@tees = Tee.where("course_id = ?", params[:id]).order("name ASC")
		render json: @tees
	end

	def get_tee
		@tee = Tee.find(params[:id])
		render json: @tee
	end

	def score_params
    	params.require(:score).permit(
							:score_hole_1,
							:score_hole_2,
							:score_hole_3,
							:score_hole_4,
							:score_hole_5,
							:score_hole_6,
							:score_hole_7,
							:score_hole_8,
							:score_hole_9,
							:score_hole_10,
							:score_hole_11,
							:score_hole_12,
							:score_hole_13,
							:score_hole_14,
							:score_hole_15,
							:score_hole_16,
							:score_hole_17,
							:score_hole_18,
							:date_played,
							:tee_id
							)
  	end
end
