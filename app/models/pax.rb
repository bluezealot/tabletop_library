class Pax < ActiveRecord::Base
  attr_accessible :end, :location, :name, :start
  
  validates :name, presence: true
  validates :location, presence: true
  validates :end, presence: true
  validates :start, presence: true
end
