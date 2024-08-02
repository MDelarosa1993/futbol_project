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

  def count_of_teams
    @teams.count
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
end
