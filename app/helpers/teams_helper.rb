module TeamsHelper
  
  def show_graph(graph_type)
    
    output = content_tag(:h2, "#{graph_type.titleize} Points").html_safe
    output += content_tag(:tr, content_tag(:th, '<span class=\"auraltext\">Name</span>'.html_safe) + content_tag(:th, '<span class=\"auraltext\">Points</span>'.html_safe).html_safe)
     
    @teams.each do |team|
      points = case graph_type
        when 'total'
          team.total_points
        when 'gameweek'
          team.gameweek_points
      else 
        0
      end
      if (team == @teams.first)
        class_txt = 'first'
      elsif (team == @teams.last) 
        class_txt = 'first'
      end 
       
      value_class_txt = "value #{class_txt}"
      row_output = content_tag(:td, link_to(team.manager_name, team_path(team)), :class => class_txt).html_safe
      row_output += content_tag(:td, "#{image_tag('bar.png', :width => points, :height => 16)}#{points}".html_safe, :class => value_class_txt)
      output += content_tag(:tr, row_output)

    end
    content_tag :table, output, :class => 'chart'

  end
  
  
  def show_players
    output = ''.html_safe
    output += content_tag(:tr, "#{content_tag(:th, 'Name')}#{content_tag(:th, 'Paid')}#{content_tag(:th, 'Points')}#{content_tag(:th, 'Start Week')}#{content_tag(:th, 'End Week')}".html_safe)
    @team.members.each do |member|
      player = member.player
      row_output = content_tag(:td, link_to(player.full_name, player_path(player))).html_safe
      row_output += content_tag(:td, member.display_price)
      row_output += content_tag(:td, player.total_points)
      row_output += content_tag(:td, member.start_week)
      row_output += content_tag(:td, member.end_week)

      output += content_tag(:tr, row_output)
    end
    content_tag :table, output
  end
end
