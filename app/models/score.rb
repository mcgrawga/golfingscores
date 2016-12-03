class Score < ActiveRecord::Base
	belongs_to :tee

	validates 	:score_hole_1, :score_hole_2, :score_hole_3, :score_hole_4, 
				:score_hole_5, :score_hole_6, :score_hole_7, :score_hole_8, 
				:score_hole_9, :numericality => { :greater_than_or_equal_to => 1, :less_than_or_equal_to => 10 }
	validates 	:putts_hole_1, :putts_hole_2, :putts_hole_3, :putts_hole_4, 
				:putts_hole_5, :putts_hole_6, :putts_hole_7, :putts_hole_8, 
				:putts_hole_9, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 10 }
	validate :front9_back9_or_both
	validate :putts

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
	   			current_hole = "putts_hole_" + i.to_s
	   			if (send(current_hole).blank?)
	   				errors.add(:base, "Must enter a putt score for all 9 holes.")
	   				break
	   			end
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

end
