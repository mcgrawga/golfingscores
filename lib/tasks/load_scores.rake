require 'rake'

task :load_scores => :environment do
  s = Score.new
  s.tee_id = 12
  s.date_played = "2016-10-12 00:00:00"
  s.score_hole_1 = 3 
  s.score_hole_2 = 3
  s.score_hole_3 = 3
  s.score_hole_4 = 3
  s.score_hole_5 = 3
  s.score_hole_6 = 3
  s.score_hole_7 = 3
  s.score_hole_8 = 3
  s.score_hole_1 = 3
  s.score_hole_1 = 3
  s.score_hole_1 = 3
  s.score_hole_1 = 3
  s.score_hole_1 = 3
  s.score_hole_1 = 3
  s.score_hole_1 = 3
  s.score_hole_1 = 3
  s.score_hole_1 = 3
  s.score_hole_1 = 3
	t.integer  "score_hole_1"
	t.integer  "score_hole_2"
	t.integer  "score_hole_3"
	t.integer  "score_hole_4"
	t.integer  "score_hole_5"
	t.integer  "score_hole_6"
	t.integer  "score_hole_7"
	t.integer  "score_hole_8"
	t.integer  "score_hole_9"
	t.integer  "score_hole_10"
	t.integer  "score_hole_11"
	t.integer  "score_hole_12"
	t.integer  "score_hole_13"
	t.integer  "score_hole_14"
	t.integer  "score_hole_15"
	t.integer  "score_hole_16"
	t.integer  "score_hole_17"
	t.integer  "score_hole_18"
	t.integer  "putts_hole_1"
	t.integer  "putts_hole_2"
	t.integer  "putts_hole_3"
	t.integer  "putts_hole_4"
	t.integer  "putts_hole_5"
	t.integer  "putts_hole_6"
	t.integer  "putts_hole_7"
	t.integer  "putts_hole_8"
	t.integer  "putts_hole_9"
	t.integer  "putts_hole_10"
	t.integer  "putts_hole_11"
	t.integer  "putts_hole_12"
	t.integer  "putts_hole_13"
	t.integer  "putts_hole_14"
	t.integer  "putts_hole_15"
	t.integer  "putts_hole_16"
	t.integer  "putts_hole_17"
	t.integer  "putts_hole_18"
	t.integer  "fairways_hit"
	t.integer  "greens_in_regulation"
	t.integer  "penalties"
	t.datetime "created_at",           null: false
	t.datetime "updated_at",           null: false
	t.text     "notes"
  s.save
end