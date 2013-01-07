class Game < ActiveRecord::Base
  set_primary_key :barcode
  attr_accessible :barcode, :checked_in, :loaner_id, :section_id, :title_id, :returned
  belongs_to :title
  belongs_to :section
  
  has_many :checkouts
  
  validates_format_of :barcode, :with => /[a-z]{3}\d{4}[a-z0-9]{2}/i
  #validates :barcode, presence: true
  validates_existence_of :title, :both => false
  validates_existence_of :section, :both => false
  
  validates_uniqueness_of :barcode
  
end
