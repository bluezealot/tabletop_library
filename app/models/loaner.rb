class Loaner < ActiveRecord::Base
  attr_accessible :contact, :name, :phone_number

  has_many :games
  
  validates_uniqueness_of :name
  validates :name,              presence: true
  validates_format_of :phone_number, :with => /^\d{3}-?\d{3}-?\d{4}$/i
end
