class Note < ActiveRecord::Base
  attr_accessible :game_id, :text
  
  belongs_to :game
  
  validates :text, length: { minimum: 1 }
  validates_existence_of :game, :both => false
  
end
