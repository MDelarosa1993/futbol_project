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
  
  def average_goals_per_game
    total_goals = @games.sum do |row|
      row.home_goals + row.away_goals
    end
    total_games = @games.count
    (total_goals / total_games.to_f).round(2)
  end

  def average_goals_by_season
    games_by_season = @games.each_with_object(Hash.new { |hash, key| hash[key] = { total_goals: 0, count: 0 } }) do |row, hash|
      season = row[:season]
      hash[season][:total_goals] += row[:home_goals].to_i + row[:away_goals].to_i
      hash[season][:count] += 1
    end

    games_by_season.each_with_object({}) do |(season, data), result|
      result[season] = (data[:total_goals] / data[:count].to_f).round(2)
    end
  end
 
end