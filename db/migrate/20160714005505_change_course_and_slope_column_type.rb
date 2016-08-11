class ChangeCourseAndSlopeColumnType < ActiveRecord::Migration
  def change
  	change_column :tees, :course_rating, :decimal
  	change_column :tees, :slope_rating, :integer
  end
end
