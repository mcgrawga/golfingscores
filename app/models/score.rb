class Score < ActiveRecord::Base
	belongs_to :tee

	validates :score_hole_1, :numericality => { :greater_than_or_equal_to => 1 }, 
	presence: true

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
