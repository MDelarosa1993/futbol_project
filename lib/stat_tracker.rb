require 'csv'
require_relative 'game'
require_relative 'team'
require_relative 'game_team'

class StatTracker

  attr_reader :games, :teams, :game_teams

  def self.from_csv(locations)
    games = []
    teams = []
    game_teams = []
    
    CSV.foreach(locations[:games], headers: true, header_converters: :symbol) do |row|
      games << Game.new(row.to_h)
    end
    CSV.foreach(locations[:teams], headers: true, header_converters: :symbol) do |row|
      teams << Team.new(row.to_h)
    end
    CSV.foreach(locations[:game_teams], headers: true, header_converters: :symbol) do |row|
      game_teams << GameTeam.new(row.to_h)
    end

    new(games, teams, game_teams)
  end

  def initialize(games, teams, game_teams)
    @games = games
    @teams = teams
    @game_teams = game_teams
  end

  def highest_total_score
    total_score.max
  end

  def lowest_total_score
    total_score.min
  end

  def total_score 
    @games.map do |game| #rows
      home_goals = game.home_goals
      away_goals = game.away_goals
      home_goals + away_goals
    end
  end

  def count_of_games_by_season
    count = Hash.new(0)
    @games.each do |game|
      count[game.season] += 1
    end
    count
  end

  def percentage_home_wins
    total_games = @games.size
    home_wins = @games.count do |game| 
      game.home_goals > game.away_goals
    end
    percentage = (home_wins.to_f / total_games)
    percentage.round(2)
  end

  def percentage_visitor_wins
    total_games = @games.size
    visitor_wins = @games.count do |game| 
      game.away_goals > game.home_goals
    end
    percentage = (visitor_wins.to_f / total_games)
    percentage.round(2)
  end

  def percentage_ties
    total_games = @games.size
    ties = @games.count do |game| 
      game.away_goals == game.home_goals
    end
    percentage = (ties.to_f / total_games)
    percentage.round(2)
  end

  def average_goals_per_game
    total_goals = 0
    total_games = 0
    @games.each do |game|
      total_goals += game.away_goals + game.home_goals
      total_games += 1
    end

    if total_games > 0
      average_goals = total_goals.to_f / total_games
    else
      average_goals = 0.0
    end
    average_goals_rounded = average_goals.round(2)
    average_goals_rounded
  end
  

  def average_goals_by_season
    games_by_season = @games.group_by { |game| game.season }
    
    averages = games_by_season.each_with_object({}) do |(season, games), hash|
      total_goals = games.sum { |game| game.away_goals + game.home_goals }
      total_games = games.size
      average = (total_goals.to_f / total_games)
      hash[season] = average.round(2)
    end
    # averages = a hash that contains the avg goals
    # per game for each seaosn
    averages
  end

  def most_accurate_team(season)
    team_ratios(season)
    require 'pry'; binding.pry
    # sort through the list of ratios to find the BEST one
    # then use the id number to find the corresponding team name
  end

  # def least_accurate_team(season)
  #   team_ratios(season)
  #    # sort through the list of ratios to find the WORST one
  #   # then use the id number to find the corresponding team name
  # end

  def team_ratios(season)
    
    hash = {}
    seasons = @games.each do |game|
      hash[game.season] = {}
    end
    
    @game_teams.each do |game_team|
      if season[0, 4] == game_team.game_id[0, 4]
        ratio = if game_team.goals != 0
          game_team.shots / game_team.goals
        else
          0
        end
        team_name = nil
        @teams.find do |team|
          if game_team.team_id == team.team_id
            team_name = team.team_name
          end
        end
        hash[season][team_name] = ratio
      end
    end
    hash
  end
  
  # def team_ratios(season)
  #   games_by_season = @games.group_by { |game| game.season }

  #   team_id_with_ratio = {}

  #   # get the game_id, shots/goals ratio, and team_id number
    # @game_teams.group_by do |game|
    #   ratio = if game.goals != 0
    #     game.shots / game.goals
    #   else
    #     0
    #   end
    #   team_id_with_ratio[game.team_id] = {ratio: ratio, game_id: game.game_id}
    # end
    
  #   # we now have game objects sorted by season,
  #   # and a hash with the team_id, their ratio, and the game number
  #   # now sort the ratios by season
  #   season_ratios = {}

  #   games_by_season[season].each do |game|
  #     team_id_with_ratio.each do |team, info|
  #       # require 'pry'; binding.pry
  #       info.each do |x|
  #         # require 'pry'; binding.pry
  #         if x[0] == :game_id && x[1] == game.game_id
  #           season_ratios[team] = info[:ratio]
  #         end
  #       end
  #     end
  #   end
  #   require 'pry'; binding.pry
    
  #   # we need to go through the team_id_with_ratio hash and match the game number with the season
  #   # and return the seasons ratios and the team's corresponding id number
  # end

end
