class Team < ActiveRecord::Base
  has_many :members
  has_many :players, :through => :members
  
  
  def self.load_yaml_team_data
    File.open("lib/team_data.yml", 'r') do |file|
      YAML::load(file).each do |record|
        puts record.inspect
        team_name = record[0]
        team_data = record[1]
        team = Team.find_by_team_name(team_name)
        unless team
          team = Team.new
        end
        #puts team.inspect
        manager_name = team_data['name']
        team.attributes = {:team_name => team_name, :manager_name => manager_name}
        team.save!

        team.members.each {|member| member.destroy} unless team.members.blank?
        
        team_data.inspect
        team_data['starting_players'].each do |a|
          ff_id = a[0]
          price_paid = a[1]*10
          #puts "player id #{ff_id}"
          #puts "price_paid #{price_paid}"
          player = Player.find_by_ff_id(ff_id)
          member = team.members.build({:player_id => player.id, :price_paid => price_paid, :start_week => 1})
          puts member.inspect
        end
        puts team.inspect
        team.save!
      end
    end
  end
  
  def total_points
    total = 0 
    self.players.each {|p| total+=p.total_points}
    total
    
  end
  
  def gameweek_points
    total = 0 
    self.players.each {|p| total+=p.gameweek_points}
    total
    
  end
  
  def cost
    total = Float(0)
    self.members.each {|member| total+=member.price_paid}
    total
  end
  def remaining
    1000-cost
  end
  def cost_to_s
    return "#{Float(cost/10)}m"
  end
  def remaining_to_s
    return "#{Float(remaining/10)}m"

  end
  
end
