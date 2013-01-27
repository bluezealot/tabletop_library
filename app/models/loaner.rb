class Loaner < ActiveRecord::Base
  attr_accessible :contact, :name, :phone_number

  has_many :games
  
  validates_uniqueness_of :name
  validates :name, presence: true
  validates_format_of :phone_number, :with => /^\D*\d\D*\d\D*\d\D*\d\D*\d\D*\d\D*\d\D*\d\D*\d\D*\d\D*$/i
end
