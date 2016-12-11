class Score < ActiveRecord::Base
	belongs_to :tee

	validates 	:score_hole_1, :score_hole_2, :score_hole_3, :score_hole_4, 
				:score_hole_5, :score_hole_6, :score_hole_7, :score_hole_8, 
				:score_hole_9, :score_hole_10, :score_hole_11, :score_hole_12, 
				:score_hole_13, :score_hole_14, :score_hole_15, :score_hole_16, 
				:score_hole_17, :score_hole_18, 
				:numericality => { :greater_than_or_equal_to => 1, :less_than_or_equal_to => 10 }, allow_nil: true
	validates 	:putts_hole_1, :putts_hole_2, :putts_hole_3, :putts_hole_4, 
				:putts_hole_5, :putts_hole_6, :putts_hole_7, :putts_hole_8, 
				:putts_hole_9, :putts_hole_10, :putts_hole_11, :putts_hole_12, 
				:putts_hole_13, :putts_hole_14, :putts_hole_15, :putts_hole_16, 
				:putts_hole_17, :putts_hole_18, 
				:numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 10 }, allow_nil: true
	validate :front9_back9_or_both
	validate :putts
	validate :gir
	validate :fir
	validates :penalties, :numericality => { :greater_than_or_equal_to => 0 }, allow_nil: true

	def gir
		if (tee.par_hole_10.blank?)  #9 hole
			if (!greens_in_regulation.blank? && greens_in_regulation > 9)
				errors.add(:base, "You can't hit more greens in regulation than holes you played.")
				return
			end
		else  #18 hole
			holes_played = 0
			(1..18).each do |i|
				score_hole = "score_hole_" + i.to_s
	   			if (!send(score_hole).blank?)
	   				holes_played = holes_played + 1
	   			end
			end
			if (!greens_in_regulation.blank? && greens_in_regulation > holes_played)
				errors.add(:base, "You can't hit more greens in regulation than holes you played.")
				return
			end
		end
	end

	def fir
		num_fairways = 0
		num_holes = 18
		if (tee.par_hole_10.blank?)  #9 hole
			num_holes = 9
		end
		(1..num_holes).each do |i|
			par_hole = "par_hole_" + i.to_s
			score_hole = "score_hole_" + i.to_s
			log("Hole: " + i.to_s + ", par: " + tee.send(par_hole).to_s + ", score: " + send(score_hole).to_s)
   			if ( (!tee.send(par_hole).blank?) && (tee.send(par_hole) > 3) && (!send(score_hole).blank?))
   				num_fairways = num_fairways + 1
   			end
		end
		if (!fairways_hit.blank? && fairways_hit > num_fairways)
			errors.add(:base, "You can't hit more fairways than the number of par 4s and par 5s you played.")
			return
		end
	end

	def front9_back9_or_both
		if (tee.par_hole_10.blank?)  #9 hole
			(1..9).each do |i|
	   			current_hole = "score_hole_" + i.to_s
	   			if (send(current_hole).blank?)
	   				errors.add(:base, "Must enter a score for all 9 holes.")
	   				break
	   			end
			end
		else  #18 hole
			front9_status = "Mixed"
			if (score_hole_1.blank? && score_hole_2.blank? && score_hole_3.blank? && score_hole_4.blank? && score_hole_5.blank? && score_hole_6.blank? && score_hole_7.blank? && score_hole_8.blank? && score_hole_9.blank?)
				front9_status = "All Blank";
			elsif (!score_hole_1.blank? && !score_hole_2.blank? && !score_hole_3.blank? && !score_hole_4.blank? && !score_hole_5.blank? && !score_hole_6.blank? && !score_hole_7.blank? && !score_hole_8.blank? && !score_hole_9.blank?)
				front9_status = "All Populated";
			end

			back9_status = "Mixed"
			if (score_hole_10.blank? && score_hole_11.blank? && score_hole_12.blank? && score_hole_13.blank? && score_hole_14.blank? && score_hole_15.blank? && score_hole_16.blank? && score_hole_17.blank? && score_hole_18.blank?)
				back9_status = "All Blank";
			elsif (!score_hole_10.blank? && !score_hole_11.blank? && !score_hole_12.blank? && !score_hole_13.blank? && !score_hole_14.blank? && !score_hole_15.blank? && !score_hole_16.blank? && !score_hole_17.blank? && !score_hole_18.blank?)
				back9_status = "All Populated";
			end
			if ( (front9_status == "Mixed" || back9_status == "Mixed") || (front9_status == "All Blank" && back9_status == "All Blank"))
				errors.add(:base, "You must enter a complete front 9, back 9 or all 18 holes.")
				return
			end
		end
	end

	def putts
		if (tee.par_hole_10.blank?)  #9 hole
			(1..9).each do |i|
				score_hole = "score_hole_" + i.to_s
	   			putts_hole = "putts_hole_" + i.to_s
	   			if (send(score_hole).blank? && !send(putts_hole).blank?)
	   				errors.add(:base, "You can't enter putts for a hole with no score.")
	   				return
	   			end
			end
			front9_status = "Mixed"
			if (putts_hole_1.blank? && putts_hole_2.blank? && putts_hole_3.blank? && putts_hole_4.blank? && putts_hole_5.blank? && putts_hole_6.blank? && putts_hole_7.blank? && putts_hole_8.blank? && putts_hole_9.blank?)
				front9_status = "All Blank";
			elsif (!putts_hole_1.blank? && !putts_hole_2.blank? && !putts_hole_3.blank? && !putts_hole_4.blank? && !putts_hole_5.blank? && !putts_hole_6.blank? && !putts_hole_7.blank? && !putts_hole_8.blank? && !putts_hole_9.blank?)
				front9_status = "All Populated";
			end

			if (front9_status == "Mixed")
				errors.add(:base, "You must enter all putts or none.")
				return
			end
		else  #18 hole
			(1..18).each do |i|
				score_hole = "score_hole_" + i.to_s
	   			putts_hole = "putts_hole_" + i.to_s
	   			if (send(score_hole).blank? && !send(putts_hole).blank?)
	   				errors.add(:base, "You can't enter putts for a hole with no score.")
	   				return
	   			end
			end
			front9_status = "Mixed"
			if (putts_hole_1.blank? && putts_hole_2.blank? && putts_hole_3.blank? && putts_hole_4.blank? && putts_hole_5.blank? && putts_hole_6.blank? && putts_hole_7.blank? && putts_hole_8.blank? && putts_hole_9.blank?)
				front9_status = "All Blank";
			elsif (!putts_hole_1.blank? && !putts_hole_2.blank? && !putts_hole_3.blank? && !putts_hole_4.blank? && !putts_hole_5.blank? && !putts_hole_6.blank? && !putts_hole_7.blank? && !putts_hole_8.blank? && !putts_hole_9.blank?)
				front9_status = "All Populated";
			end

			back9_status = "Mixed"
			if (putts_hole_10.blank? && putts_hole_11.blank? && putts_hole_12.blank? && putts_hole_13.blank? && putts_hole_14.blank? && putts_hole_15.blank? && putts_hole_16.blank? && putts_hole_17.blank? && putts_hole_18.blank?)
				back9_status = "All Blank";
			elsif (!putts_hole_10.blank? && !putts_hole_11.blank? && !putts_hole_12.blank? && !putts_hole_13.blank? && !putts_hole_14.blank? && !putts_hole_15.blank? && !putts_hole_16.blank? && !putts_hole_17.blank? && !putts_hole_18.blank?)
				back9_status = "All Populated";
			end
			if ( (front9_status == "Mixed" || back9_status == "Mixed") )
				errors.add(:base, "You must enter all putts or none.")
				return
			end
		end
	end

	def total
		score = 0
		(1..18).each do |i|
   			current_hole = "score_hole_" + i.to_s
   			score = score + send(current_hole).to_i
		end
		score
  	end

  	def total_front_9
		score = 0
		(1..9).each do |i|
   			current_hole = "score_hole_" + i.to_s
   			score = score + send(current_hole).to_i
		end
		score
  	end

  	def total_back_9
		score = 0
		(10..18).each do |i|
   			current_hole = "score_hole_" + i.to_s
   			score = score + send(current_hole).to_i
		end
		score
  	end

  	def total_putts
		score = 0
		(1..18).each do |i|
   			current_hole = "putts_hole_" + i.to_s
   			score = score + send(current_hole).to_i
		end
		score
  	end

  	def total_putts_front_9
		score = 0
		(1..9).each do |i|
   			current_hole = "putts_hole_" + i.to_s
   			score = score + send(current_hole).to_i
		end
		score
  	end

  	def total_putts_back_9
		score = 0
		(10..18).each do |i|
   			current_hole = "putts_hole_" + i.to_s
   			score = score + send(current_hole).to_i
		end
		score
  	end

  	def nine_or_eighteen_hole_score
		if (total_front_9 > 0 && total_back_9 > 0)
			return 18
		else
			return 9
		end
  	end

end
