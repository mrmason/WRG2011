module PlayersHelper
  def player_row_class(player)
    if player.member.nil?
      return "yes"
    else
      if player.member.end_week != 38
        return "sold"
      else
        return "no"
      end
    end
  end
end
