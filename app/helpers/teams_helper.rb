module TeamsHelper
  def show_players
    output = ''.html_safe
    output += content_tag(:tr, "#{content_tag(:th, 'Name')}#{content_tag(:th, 'Paid')}#{content_tag(:th, 'Points')}#{content_tag(:th, 'Start Week')}#{content_tag(:th, 'End Week')}".html_safe)
    @team.members.each do |member|
      player = member.player
      row_output = ''.html_safe
      row_output += content_tag(:td, player.full_name)
      row_output += content_tag(:td, member.display_price)
      row_output += content_tag(:td, player.total_points)
      row_output += content_tag(:td, member.start_week)
      row_output += content_tag(:td, member.end_week)

      output += content_tag(:tr, row_output)
    end
    content_tag :table, output
  end
end
