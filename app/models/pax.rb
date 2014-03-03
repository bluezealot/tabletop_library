class Pax < ActiveRecord::Base
  attr_accessible :end_date, :location, :name, :start_date, :current
  
  validates :name,      presence: true
  validates :location,  presence: true
  validates :end_date,       presence: true
  validates :start_date,     presence: true
  
  def full_name
      name + " | " + location
  end
  
end
