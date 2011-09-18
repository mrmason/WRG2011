class Player < ActiveRecord::Base
  
  serialize :data, Hash # This contains the JSON data from the FF website
  
  
  def to_param
    "#{id}-#{web_name}"
  end
  
  # This class is mapped to players from the fantasy football website
  
  # Method to run a full update on players
  def self.full_update
    Player.import_players
    Player.update_players
  end
  
  # Updating players from the FF website
  def self.update_players
    require 'mechanize'

    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    } 
    # Get each players JSON file, and put in into our database
    Player.all.each do |player|
      print "Updating Player #{player.web_name}"
      player.data = JSON.parse(a.get("http://fantasy.premierleague.com/web/api/elements/#{player.ff_id}/").content)
      player.save
      puts "."
    end
    puts "Done!"
  end
  
  # Importing players from the FF website
  def self.import_players
    require 'mechanize'

    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }
    
    # Login
    a.get('http://fantasy.premierleague.com/') do |page|
      result = page.form_with(:action => 'https://users.premierleague.com/PremierUser/redirectLogin') do |login|
        login.email = 'trmason@gmail.com'
        login.password = "wrg2011"
      end.submit
      # Load Transfers page
      transfers_page = a.click(result.link_with(:text => /Transfers/))
      # Pull the JSON out of the Page
      spaff = transfers_page.parser.css('div#ismJson').text
      # Turn it into JSON
      @dirty_json = JSON.parse(spaff)
    end
    
    # Get the correct JSON ...
    players = @dirty_json["elInfo"]
    clubs   = @dirty_json["teamInfo"]
    # ... and clean it up by deleing some blank records
    players.delete(nil)
    clubs.delete(nil)
    
    # Check to see if each player is in the database, and if not, let's add them.
    players.each do |player|
      if Player.find_by_ff_id(player[0]).nil?
        puts "Creating Player #{player[5]}"
        Player.create(:ff_id => player[0], :first_name => player[3], :last_name => player[4], :web_name => player[5])
      end
    end
    return "Done!"
  end
  
  #instance Variables to Get stuff out of data.
  def team 
    self.data["team_name"]
  end
  
  def value
    "#{(self.data["now_cost"].to_f/10)}m"
  end
  
  def total_points
    self.data["total_points"]
  end
  
  def full_name
    "#{last_name}, #{first_name}"
  end
  
  def gameweek_points
    self.data["fixture_history"]["summary"].last.last rescue 0
  end
  
  def photo_url
    "http://fantasy.premierleague.com/#{self.data["photo_mobile_url"]}"
  end
  
  def selected_by
    self.data["selected_by"]
  end
  
  def status
    case self.data["status"]
    when "a"
      return "Available"
    when "d"
      return "Doubtful - #{self.data["news"]}"
    when "i"
      return "Injured - #{self.data["news"]}"
    when "u"
      return "Unavailable - #{self.data["news"]}"
    end
  end
  
  def gameweek_scores
    result = Hash.new
    self.data["fixture_history"]["all"].each do |score|
      result[score[1]] = score.last
    end
    return result
  end
  
end
