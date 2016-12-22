class ScoresController < ApplicationController
	before_filter :check_for_login
	before_filter :check_for_subscription

	def index
		@scores = Score.joins("INNER JOIN tees ON tees.id = scores.tee_id INNER JOIN courses ON courses.id = tees.course_id and courses.user_id = %s" % current_user.id.to_s).order(date_played: :desc)
		log("Userid:  %s" %  current_user.id.to_s)
		scoreSum = 0
		@scores.each do |s|
			if (s.nine_or_eighteen_hole_score == 9)
				scoreSum = scoreSum + (s.total * 2)
			else
				scoreSum = scoreSum + s.total
			end
		end
		if (@scores.length > 0)
			avgScore = scoreSum / @scores.length
			@handicap = ((avgScore - 72) * 0.96 * -1).round(1) 
		else
			@handicap = 'N/A' 
		end
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
			@courses = Course.where("user_id = ?", current_user.id).order("name ASC")
			render :validate
		end
	end

	def edit
		@score = Score.find(params[:id])
		if (@score.tee.course.user_id == current_user.id)
			@courses = Course.where("user_id = ?", current_user.id).order("name ASC")
		else
			redirect_to notauthorized_path
		end
	end

	def update
		@score = Score.find(params[:id])
		@score.assign_attributes(score_params)
		@score.date_played = DateTime.strptime(score_params[:date_played], "%m/%d/%Y")
		log("Date played from parms:  " + score_params[:date_played])
		log("What it is going to get set to:  " + DateTime.strptime(score_params[:date_played], "%m/%d/%Y").to_s)
		log("Date played from object:  " + @score.date_played.to_s)
		if @score.valid?
			@score.save
			redirect_to scores_path
		else
			if (@score.tee.course.user_id == current_user.id)
				@courses = Course.where("user_id = ?", current_user.id).order("name ASC")
				render :edit
			else
				redirect_to notauthorized_path
			end
		end
	end

	def destroy
		@score = Score.find(params[:id])
		@score.destroy
		redirect_to scores_path
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
							:putts_hole_1,
							:putts_hole_2,
							:putts_hole_3,
							:putts_hole_4,
							:putts_hole_5,
							:putts_hole_6,
							:putts_hole_7,
							:putts_hole_8,
							:putts_hole_9,
							:putts_hole_10,
							:putts_hole_11,
							:putts_hole_12,
							:putts_hole_13,
							:putts_hole_14,
							:putts_hole_15,
							:putts_hole_16,
							:putts_hole_17,
							:putts_hole_18,
							:fairways_hit,
							:greens_in_regulation,
							:penalties,
							:date_played,
							:tee_id,
							:notes
							)
  	end
end
