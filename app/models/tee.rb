class Tee < ActiveRecord::Base
	belongs_to :course
	default_scope { order('name ASC') }
	has_many :scores, :dependent => :destroy

	validates :name, :course_rating, :slope_rating, :course_id, presence: true

	validates :par_hole_1, :par_hole_2, :par_hole_3, :par_hole_4, :par_hole_5, 
	:par_hole_6, :par_hole_7, :par_hole_8, :par_hole_9, :numericality => { :greater_than_or_equal_to => 3, :less_than_or_equal_to => 5 }, 
	presence: true

	validates :par_hole_10, :par_hole_11, :par_hole_12, :par_hole_13, 
	:par_hole_14, :par_hole_15, :par_hole_16, :par_hole_17, :par_hole_18, :numericality => { :greater_than_or_equal_to => 3, :less_than_or_equal_to => 5 }, 
	allow_nil: true

	validates :slope_rating, :numericality => { :greater_than_or_equal_to => 55, :less_than_or_equal_to => 155 }
	validates :course_rating, numericality: true

end
