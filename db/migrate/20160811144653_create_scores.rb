class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
    	t.integer :tee_id, null: false
    	t.datetime :date_played, null: false
		t.integer :score_hole_1, null: true
		t.integer :score_hole_2, null: true
		t.integer :score_hole_3, null: true
		t.integer :score_hole_4, null: true
		t.integer :score_hole_5, null: true
		t.integer :score_hole_6, null: true
		t.integer :score_hole_7, null: true
		t.integer :score_hole_8, null: true
		t.integer :score_hole_9, null: true
		t.integer :score_hole_10, null: true
		t.integer :score_hole_11, null: true
		t.integer :score_hole_12, null: true
		t.integer :score_hole_13, null: true
		t.integer :score_hole_14, null: true
		t.integer :score_hole_15, null: true
		t.integer :score_hole_16, null: true
		t.integer :score_hole_17, null: true
		t.integer :score_hole_18, null: true
		t.integer :putts_hole_1, null: true
		t.integer :putts_hole_2, null: true
		t.integer :putts_hole_3, null: true
		t.integer :putts_hole_4, null: true
		t.integer :putts_hole_5, null: true
		t.integer :putts_hole_6, null: true
		t.integer :putts_hole_7, null: true
		t.integer :putts_hole_8, null: true
		t.integer :putts_hole_9, null: true
		t.integer :putts_hole_10, null: true
		t.integer :putts_hole_11, null: true
		t.integer :putts_hole_12, null: true
		t.integer :putts_hole_13, null: true
		t.integer :putts_hole_14, null: true
		t.integer :putts_hole_15, null: true
		t.integer :putts_hole_16, null: true
		t.integer :putts_hole_17, null: true
		t.integer :putts_hole_18, null: true
		t.integer :fairways_hit, null: true
		t.integer :greens_in_regulation, null: true
		t.integer :penalties, null: true
		t.timestamps null: false
    end
  end
end
