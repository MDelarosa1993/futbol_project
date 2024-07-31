require 'csv'
require_relative 'games'
require_relative 'teams'

class StatTracker 
  def self.from_csv(locations)
    new(locations)
  end

  def initialize(locations)
    @games = create_objects(locations[:games], Games, self)
    @teams = create_objects(locations[:teams], Teams, self)
    @game_teams = create_objects(locations[:game_teams], GameTeams, self)

  end

  def create_objects(path, statistics, tracker)
    data = CSV.parse(File.read(path), headers: true, header_converters: :symbol)
    data.map { |row| statistics.new(row, tracker) }
  end

  def highest_total_score
      total_score.max
  end
  
  def lowest_total_score
      total_score.min
  end

  def total_score 
     @games.map do |game|
      home_goals = game.home_goals
      away_goals = game.away_goals
      home_goals + away_goals
    end
  end

  def percentage_home_wins
    home_wins = @games.count {|game|[:home_team_won]}
  end

  def percentage_visitor_wins
    visitor_wins = @games.count {|game|[:visitor_wins]}
  end

  def percentage_ties
    percentage_ties = @game.count {|game|[:games_ties]}
  end
    
end