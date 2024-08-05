require 'csv'
require_relative 'game'
require_relative 'team'
require_relative 'game_team'

class StatTracker

  attr_reader :games, :teams, :game_teams

  def self.from_csv(locations)
    teams = read_and_process_csv(locations[:teams], Team)
    game_teams = read_and_process_csv(locations[:game_teams], GameTeam)
    games = read_and_process_csv(locations[:games], Game)

    new(games, teams, game_teams)
  end

  def self.read_and_process_csv(file_path, file_class )
    CSV.foreach(file_path, headers: true, header_converters: :symbol).map do |row|
      file_class.new(row.to_h)
    end
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
    @games.map do |game|
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
    averages
  end

  def filter_games_by_season(season)
    @games.find_all { |game| game.season == season }
  end
  
  def get_game_ids_by_season(season)
    filtered_games = filter_games_by_season(season)
    game_ids = []
    filtered_games.each do |game|
      game_id = game.game_id
      game_ids << game_id
    end
    game_ids
  end
  
  def filter_game_teams_by_game_ids(game_ids)
    @game_teams.find_all { |game_team| game_ids.include?(game_team.game_id) }
  end
  
  def calculate_tackles_by_team(game_teams)
    tackles_by_team = Hash.new(0)
    game_teams.each do |game_team|
      team_id = game_team.team_id
      tackles = game_team.tackles
      tackles_by_team[team_id] += tackles
    end
    tackles_by_team
  end
  
  def find_team_by_id(team_id)
    @teams.find { |team| team.team_id == team_id }
  end

  def construct_team_names_hash
    team_names_hash = {}
    @teams.each do |team|
        team_id = team.team_id
        team_name = team.team_name
        team_names_hash[team_id] = team_name
    end
      team_names_hash  
  end

  def most_tackles(season)
    game_ids = get_game_ids_by_season(season)
    game_teams_in_season = filter_game_teams_by_game_ids(game_ids)
    tackles_by_team = calculate_tackles_by_team(game_teams_in_season)
    
    team_id_with_most_tackles = tackles_by_team.max_by { |_, tackles| tackles }&.first
    team = find_team_by_id(team_id_with_most_tackles)
    
    team.team_name
  end
  
  def fewest_tackles(season)
    game_ids_in_season = get_game_ids_by_season(season).uniq
    tackles_by_team = calculate_tackles_by_team(filter_game_teams_by_game_ids(game_ids_in_season))
    
    fewest_tackles_team_id = tackles_by_team.min_by { |_, total_tackles| total_tackles }&.first
    team_names = construct_team_names_hash
    
    team_names[fewest_tackles_team_id]
  end

  def most_accurate_team(season)
    team_ratios
    best_team = team_ratios[season[0..3]].max_by do |tr|
      tr[1]
    end
    best_team[0].team_name
  end

  def least_accurate_team(season)
    team_ratios
    worst_team = team_ratios[season[0..3]].min_by do |tr|
      tr[1]
    end
    worst_team[0].team_name
  end

  def find_game_teams_by_season(season)
    @game_teams.find_all do |gt|
      gt.game_id[0..3] == season
    end
  end

  def find_ratio(game_teams)
    shots = 0.0
    goals = 0.0
    game_teams.each do |gt|
      shots += gt.shots
      goals += gt.goals
    end
    goals / shots
  end

  def team_ratios
    seasons = @games.map { |game| game.season[0..3] }.uniq
    team_ratios_list = {}
    seasons.each do |season|
      games_in_season = find_game_teams_by_season(season)
      games_by_team_id = games_in_season.group_by { |gt| gt.team_id }
      team_ratios_list[season] = games_by_team_id.map do |team_id, games|
        [@teams.find {|team| team.team_id == team_id}, find_ratio(games)]
      end
    end
    team_ratios_list
  end

  def calculate_average_goals
    game_team_goals = Hash.new { |hash, key| hash[key] = [] }
    @game_teams.each do |game_team|
      game_team_goals[game_team.team_id.to_sym] << game_team.goals.to_i
    end
    game_team_goals.transform_values do |goals|
      goals.sum.to_f / goals.size
    end
  end
   
  def find_team_name_by_id(team_id)
    team = @teams.find { |t| t.team_id == team_id.to_s }
    team.team_name if team
  end
  
  def best_offense
    average_goals = calculate_average_goals
    best_team_id = average_goals.max_by { |_, avg_goals| avg_goals }.first
    find_team_name_by_id(best_team_id)
  end
  
  def worst_offense
    average_goals = calculate_average_goals
    worst_team_id = average_goals.min_by { |_, avg_goals| avg_goals }.first
    find_team_name_by_id(worst_team_id)
  end

  def average_scores_by_hoa(hoa)
    scores = Hash.new { |hash, key| hash[key] = { goals: 0, games: 0 } }
    @game_teams.each do |game_team|
      if game_team.hoa == hoa
        scores[game_team.team_id][:goals] += game_team.goals
        scores[game_team.team_id][:games] += 1
      end
    end
    scores.transform_values { |data| data[:games] > 0 ? data[:goals].to_f / data[:games] : 0.0 }
  end

  def highest_scoring_team_by_hoa(hoa)
    average_scores = average_scores_by_hoa(hoa)
    highest_scoring_team_id = average_scores.max_by { |_, average_goals| average_goals }&.first
    find_team_by_id(highest_scoring_team_id).team_name  
  end

  def lowest_scoring_team_by_hoa(hoa)
    average_scores = average_scores_by_hoa(hoa)
    lowest_scoring_team_id = average_scores.min_by { |_, average_goals| average_goals }&.first
    find_team_by_id(lowest_scoring_team_id).team_name
  end

  def highest_scoring_visitor
    highest_scoring_team_by_hoa('away')
  end

  def highest_scoring_home_team
    highest_scoring_team_by_hoa('home')
  end

  def lowest_scoring_visitor
    lowest_scoring_team_by_hoa('away')
  end

  def lowest_scoring_home_team
    lowest_scoring_team_by_hoa('home')
  end
end
