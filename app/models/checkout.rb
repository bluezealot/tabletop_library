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

  def play_time_formatted
    unless return_time.nil?
      Time.at(return_time - check_out_time).utc.strftime('%H:%M:%S:%L')
    else
      Time.at(Time.new - check_out_time).utc.strftime('%H:%M:%S:%L')
    end
  end

  def play_time
    unless return_time.nil?
      return_time - check_out_time
    else
      0
    end
  end
  
  private
  def format_num (num)
    (num * 100).round / 100.0
  end
  
end
