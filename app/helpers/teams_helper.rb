module TeamsHelper
  
  def show_graph(graph_type)
    
    output = content_tag(:h2, "#{graph_type.titleize} Points").html_safe
    output += content_tag(:tr, content_tag(:th, '<span class=\"auraltext\">Name</span>'.html_safe) + content_tag(:th, '<span class=\"auraltext\">Points</span>'.html_safe).html_safe)
    points_type = case graph_type
        when 'total'
          'total_points'
        when 'gameweek'
          'gameweek_points'
       end
    
    teams_list = @teams.map{|t| [t.send(points_type), t]}.sort {|x,y| y <=> x }
    max_points = teams_list.first[0]
    
    
    teams_list.each do |t|
      points = t[0]
      team = t[1]
      width = (288/max_points) * points
      if (team == @teams.first)
        class_txt = 'first'
      elsif (team == @teams.last) 
        class_txt = 'first'
      end 
      value_class_txt = "value #{class_txt}"
      row_output = content_tag(:td, link_to(team.manager_name, team_path(team)), :class => class_txt).html_safe
      row_output += content_tag(:td, "#{image_tag('bar.png', :width => width, :height => 16)}#{points}".html_safe, :class => value_class_txt)
      output += content_tag(:tr, row_output)

    end
    content_tag :table, output, :class => 'chart'

  end
  
  
  def show_players
    output = ''.html_safe
    output += content_tag(:tr, "#{content_tag(:th, 'Name')}#{content_tag(:th, 'Paid')}#{content_tag(:th, 'Points')}#{content_tag(:th, 'Points in this Team')}#{content_tag(:th, 'Start Week')}#{content_tag(:th, 'End Week')}#{content_tag(:th, 'Status')}".html_safe)
    @team.members.each do |member|
      output += player_row(member) if member.current
    end
    
    @team.members.each do |member|
     output +=  player_row(member) unless member.current
    end
    
    content_tag :table, output, :class => 'view'
  end
  
  def player_row(member)
      player = member.player
      row_output = content_tag(:td, link_to(player.full_name, player_path(player))).html_safe
      row_output += content_tag(:td, member.display_price)
      row_output += content_tag(:td, player.total_points)
      row_output += content_tag(:td, member.total_points)
     
      row_output += content_tag(:td, member.start_week)
      row_output += content_tag(:td, member.end_week)
      row_output += content_tag(:td, player.status)
      row_class = member.current ? '' : 'old' 
      return content_tag(:tr, row_output, :class => row_class)
  end
end
