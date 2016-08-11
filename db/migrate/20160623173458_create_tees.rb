class CreateTees < ActiveRecord::Migration
  def change
    create_table :tees do |t|
    	t.string :name,	null: false, default: ""
		t.decimal :course_rating, null: false
		t.integer :slope_rating, null: false
		t.integer :course_id, null: false
		t.integer :par_hole_1, null: false
		t.integer :par_hole_2, null: false
		t.integer :par_hole_3, null: false
		t.integer :par_hole_4, null: false
		t.integer :par_hole_5, null: false
		t.integer :par_hole_6, null: false
		t.integer :par_hole_7, null: false
		t.integer :par_hole_8, null: false
		t.integer :par_hole_9, null: false
		t.integer :par_hole_10, null: true
		t.integer :par_hole_11, null: true
		t.integer :par_hole_12, null: true
		t.integer :par_hole_13, null: true
		t.integer :par_hole_14, null: true
		t.integer :par_hole_15, null: true
		t.integer :par_hole_16, null: true
		t.integer :par_hole_17, null: true
		t.integer :par_hole_18, null: true
		t.timestamps null: false
    end
  end
end
