class PlayersController < ApplicationController
  # GET /players
  # GET /players.xml
  def index
    @players = Player.all.sort! { |a,b| a.total_points <=> b.total_points }.reverse

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @players }
    end
  end

  # GET /players/1
  # GET /players/1.xml
  def show
    @player = Player.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @player }
    end
  end


end
