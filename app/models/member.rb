class Member < ActiveRecord::Base
  validates_presence_of :player, :team
  belongs_to :player
  belongs_to :team
  
  def display_price
    "#{(Float(self.price_paid)/10)}m"

  end
end
