task :deploy => :environment do
  Player.full_update
  Team.load_yaml_team_data
end