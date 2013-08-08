class Todo < ActiveRecord::Base
	belongs_to :user
  	attr_accessible :deadline, :description, :done, :user_id
end
