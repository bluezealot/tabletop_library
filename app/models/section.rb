class Section < ActiveRecord::Base
  attr_accessible :name
  has_many :games
  
  validates :name, presence: true
end
