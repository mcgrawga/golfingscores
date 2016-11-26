class Score < ActiveRecord::Base
	belongs_to :tee

	def total
		score = 0
		(1..18).each do |i|
   			current_hole = "score_hole_" + i.to_s
   			score = score + send(current_hole).to_i
		end
		score
  	end
end
