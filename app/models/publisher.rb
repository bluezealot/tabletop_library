class Publisher < ActiveRecord::Base
  attr_accessible :name
  has_many :titles
  
  validates :name, presence: true
  validates_uniqueness_of :name #handled by code but...
end
