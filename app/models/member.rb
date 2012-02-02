class Member < ActiveRecord::Base
  validates_presence_of :player, :team
  belongs_to :player
  belongs_to :team
  
  def display_price
    "#{(Float(self.price_paid)/10)}m"

  end
  
  def total_points
    player.points_between(start_week,end_week)
  end
  
  #Player is current if they were sold before week 24 and the date is before 1st Feb 2012
  #Or if the end week is greater than 24
  def current
    ((end_week > 23) or (end_week < 24 and Date.today < Date.new(2012, 2, 1)))
  end
  
  def original
    start_week == 1
  end
  
  
end
