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
          member = team.members.build({:player_id => player.id, :price_paid => price_paid, :start_week => a[2], :end_week => a[3]})
          puts member.inspect
        end
        puts team.inspect
        team.save!
      end
    end
  end
  
  def self.home_page
    teams = Hash.new
    Team.all.each do |t|
      teams[t] = t.total_points
    end
    return teams.sort {|a,b| a[1] <=> b[1]}.reverse
  end
  def fit_players
    total = 0 
    self.players.each {|p| total += 1 unless p.status != "Available"}
    total
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
  
  def sales
    total = Float(0)
    self.members.where("end_week != 38").each {|member| total+=member.price_paid}
    total/2
  end
  
  def remaining
    # need to work out how much everything cost and then credit half for sales
    1000-cost+sales    
  end
  
  def cost_to_s
    return "#{Float(cost/10)}m"
  end
  def remaining_to_s
    return "#{Float(remaining/10)}m"
  end
  
  
  def self.scores_hash
    teams = Hash.new
    Team.all.each do |t|
      # Build a 38 gameweek blank array
      team_score = Hash.new
      i = 1
      while i < 39
        team_score[i] = 0
        i += 1
      end
      
      t.players.each do |p|
        p.gameweek_scores.each do |gw,ps|
          team_score[gw] += ps
        end
      end
      teams[t] = {:weekly => team_score}
    end
    
    # Now lets calculate totals
    teams.each do |t,data|
      total_score = Hash.new
      total = 0
      data[:weekly].each do |gw,gw_score|
        total_score[gw] = total + gw_score
        total += gw_score
      end
      teams[t][:totals] = total_score
    end 
    return teams
  end
  
  def self.team_graph
    t = Hash.new
    teams = Team.scores_hash
    teams.each do |team,data|
      scores = Array.new
      data[:totals].each do |wg,total|
        scores << total
      end
      t[team] = scores
    end
    return t
  end
end
