class Title < ActiveRecord::Base
  attr_accessible :publisher_id, :title
  belongs_to :publisher
  has_many :games
  
  validates :title, presence: true
  validates :publisher_id, presence: true
  validates_existence_of :publisher, :both => false
  
  validates_uniqueness_of :title #handled by code but...
end
