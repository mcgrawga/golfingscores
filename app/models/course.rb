class Course < ActiveRecord::Base
	belongs_to :user
	has_many :tees, :dependent => :destroy
	validates :name, :city, :state, presence: true
end
