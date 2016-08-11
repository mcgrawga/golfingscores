class Course < ActiveRecord::Base
	belongs_to :user
	has_many :tees, -> { order "name asc" }
	validates :name, :city, :state, presence: true
end
