class AddNotesToScore < ActiveRecord::Migration
  def change
  	add_column :scores, :notes, :text
  end
end
