class Checkout < ActiveRecord::Base
  attr_accessible :attendee_id, :check_out_time, :closed, :game_id, :pax_id, :return_time
  belongs_to :attendee
  belongs_to :game
  belongs_to :pax
  
  validates :check_out_time, presence: true
  validates :attendee_id, presence: true
  validates :game_id, presence: true
  validates :pax_id, presence: true
  
  validates_existence_of :attendee, :both => false
  validates_existence_of :game, :both => false
  validates_existence_of :pax, :both => false
end
