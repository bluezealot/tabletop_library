class Pax < ActiveRecord::Base
  attr_accessible :end, :location, :name, :start, :current
  
  validates :name,      presence: true
  validates :location,  presence: true
  validates :end,       presence: true
  validates :start,     presence: true
  
  def full_name
      name + " | " + location
  end
  
end
