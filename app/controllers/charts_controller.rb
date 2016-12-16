class SingleScore
	attr_accessor :id
	attr_accessor :year
	attr_accessor :month
	attr_accessor :day
	attr_accessor :total
	attr_accessor :course
	attr_accessor :avg_putts_per_green
end

class PuttDistribution
	attr_accessor :zero
	attr_accessor :one
	attr_accessor :two
	attr_accessor :three
	attr_accessor :four
	attr_accessor :other
end

class GreensInRegulation
	attr_accessor :greensInRegulation
	attr_accessor :greensNotInRegulation
end


class ChartsController < ApplicationController
	before_filter :check_for_login
	before_filter :check_for_subscription

	def index
		@scores = Score.joins("INNER JOIN tees ON tees.id = scores.tee_id INNER JOIN courses ON courses.id = tees.course_id and courses.user_id = %s" % current_user.id.to_s).order(date_played: :desc)
	end

	def get_recent_scores_18
		@recentScores = Array.new
		@scores = Score.joins("INNER JOIN tees ON tees.id = scores.tee_id INNER JOIN courses ON courses.id = tees.course_id and courses.user_id = %s" % current_user.id.to_s).order(date_played: :desc)
		num_scores_to_list = 20		#Number of scores you want to list in recent scores graph maximum
		num_scores_listed = 0
		@scores.each do |s|
			if (s.nine_or_eighteen_hole_score == 18)
				@score = SingleScore.new
				@score.id = s.id
				@score.day = s.date_played.day
				@score.month = s.date_played.month
				@score.year = s.date_played.year
				@score.total = s.total
				@score.course = s.tee.course.name
				@score.course = @score.course + "  (" + s.tee.name + ")"
				@recentScores.push(@score)
				num_scores_listed = num_scores_listed + 1
				if (num_scores_listed >= num_scores_to_list)
					break
				end
			end
		end
		render json: @recentScores		
	end

	def get_recent_scores_9
		@recentScores = Array.new
		@scores = Score.joins("INNER JOIN tees ON tees.id = scores.tee_id INNER JOIN courses ON courses.id = tees.course_id and courses.user_id = %s" % current_user.id.to_s).order(date_played: :desc)
		num_scores_to_list = 20		#Number of scores you want to list in recent scores graph maximum
		num_scores_listed = 0
		@scores.each do |s|
			if (s.nine_or_eighteen_hole_score == 9)
				@score = SingleScore.new
				@score.id = s.id
				@score.day = s.date_played.day
				@score.month = s.date_played.month
				@score.year = s.date_played.year
				@score.total = s.total
				@score.course = s.tee.course.name
				@score.course = @score.course + "  (" + s.tee.name + ")"
				@recentScores.push(@score)
				num_scores_listed = num_scores_listed + 1
				if (num_scores_listed >= num_scores_to_list)
					break
				end
			end
		end
		render json: @recentScores		
	end

	def get_average_putts_per_green_per_round
		@recentScores = Array.new
		@scores = Score.joins("INNER JOIN tees ON tees.id = scores.tee_id INNER JOIN courses ON courses.id = tees.course_id and courses.user_id = %s" % current_user.id.to_s).order(date_played: :desc)
		num_scores_to_list = 20		#Number of scores you want to list in recent scores graph maximum
		num_scores_listed = 0
		@scores.each do |s|
			@score = SingleScore.new
			@score.id = s.id
			@score.day = s.date_played.day
			@score.month = s.date_played.month
			@score.year = s.date_played.year
			@score.total = s.total
			@score.course = s.tee.course.name
			@score.course = @score.course + "  (" + s.tee.name + ")"
			if (s.nine_or_eighteen_hole_score == 9 && s.total_putts > 0)
				@score.avg_putts_per_green = (s.total_putts.to_f / 9).round(1);
			elsif (s.nine_or_eighteen_hole_score == 18 && s.total_putts > 0)
				@score.avg_putts_per_green = (s.total_putts.to_f / 18).round(1);
			end
			@recentScores.push(@score)
			num_scores_listed = num_scores_listed + 1
			if (num_scores_listed >= num_scores_to_list)
				break
			end
		end
		render json: @recentScores		
	end

	def putt_distribution
		@PuttDistribution = PuttDistribution.new
		@PuttDistribution.zero = 0
		@PuttDistribution.one = 0
		@PuttDistribution.two = 0
		@PuttDistribution.three = 0
		@PuttDistribution.four = 0
		@PuttDistribution.other = 0
		@scores = Score.joins("INNER JOIN tees ON tees.id = scores.tee_id INNER JOIN courses ON courses.id = tees.course_id and courses.user_id = %s" % current_user.id.to_s).order(date_played: :desc)
		num_scores_to_list = 20		#Number of scores you want to list in recent scores graph maximum
		num_scores_listed = 0
		@scores.each do |s|
			(1..18).each do |i|
				putt_score = s.send("putts_hole_" + i.to_s)
				if (!putt_score.blank?)
					if ( putt_score == 0)
						@PuttDistribution.zero = @PuttDistribution.zero + 1
					elsif (putt_score == 1)
						@PuttDistribution.one = @PuttDistribution.one + 1
					elsif (putt_score == 2)
						@PuttDistribution.two = @PuttDistribution.two + 1
					elsif (putt_score == 3)
						@PuttDistribution.three = @PuttDistribution.three + 1
					elsif (putt_score == 4)
						@PuttDistribution.four = @PuttDistribution.four + 1
					elsif (putt_score > 4)
						@PuttDistribution.other = @PuttDistribution.other + 1
					end
				end
			end
		end
		render json: @PuttDistribution		
	end

	def gir
		@GreensInRegulation = GreensInRegulation.new
		@GreensInRegulation.greensInRegulation = 0
		@GreensInRegulation.greensNotInRegulation = 0
		@scores = Score.joins("INNER JOIN tees ON tees.id = scores.tee_id INNER JOIN courses ON courses.id = tees.course_id and courses.user_id = %s" % current_user.id.to_s).order(date_played: :desc)
		num_scores_to_list = 20		#Number of scores you want to list in recent scores graph maximum
		num_scores_listed = 0
		@scores.each do |s|
			if (!s.greens_in_regulation.blank?)
				@GreensInRegulation.greensInRegulation = @GreensInRegulation.greensInRegulation + s.greens_in_regulation
				if (s.nine_or_eighteen_hole_score == 18)
					@GreensInRegulation.greensNotInRegulation = (18 - s.greens_in_regulation)
				elsif (s.nine_or_eighteen_hole_score == 9)
					@GreensInRegulation.greensNotInRegulation = (9 - s.greens_in_regulation)
				end
			end
		end
		render json: @GreensInRegulation		
	end
end
