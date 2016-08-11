class ModifyCourses < ActiveRecord::Migration
  def change
  	rename_column :courses, :userid, :user_id
  end
end
