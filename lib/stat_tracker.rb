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

  def most_tackles(season) 
    # This iteration will filter out the games that dont belong to the season
    # the filtered_games variable will contain only the games that are from the given season
    filtered_games = @games.select do |game|
      game.season == season
    end
    # We are extracting game_ids values from the filtered_games array
    # game_ids will be an array containing game_ids values from the games filtered before
    game_ids = filtered_games.map do |game|
      game.game_id
    end
    # this is filtering through game_teams array to include only game_teams objects whose
    # game_id is in the game_ids array, retrieves all gameteams for games for that season
    # gameteamsinseason will be an array of game_team objects 
    game_teams_in_season = @game_teams.find_all do |game_team|
      game_ids.include?(game_team.game_id)
    end

    
    tackles_by_team = game_teams_in_season # this is an array of gameteam objects for specif seasons
      .group_by(&:team_id) # this is game_team.team_id for each game object, game_team is grouped by team_id
      .transform_values do |game_teams| # This method takes a block and transforms the values of a hash, leaving the keys unchanged.
        # this block processes each value of the hash (which is an array of game_team objects).
        game_teams.sum(&:tackles) # This calculates the sum of the tackles attribute for all game_team objects in the game_teams array. 
        #The &:tackles is a shorthand for game_team.tackles, which sums up the tackles values.
      end

    # This is a hash where the keys are team_ids and the values are the total number of tackles for each team.
    team_id_with_most_tackles = tackles_by_team.max_by do |team_id, tackles| 
      tackles
      # do |team_id, tackles| tackles end: This block specifies that the maximum value should be determined by the tackles value. 
      # max_by will look at the number of tackles and return the team_id with the highest number of tackles.
    end.first # his method extracts the first element from the result of max_by, which is the team_id with the most tackles.

    
    team = @teams.find do |team|
      team.team_id == team_id_with_most_tackles
    end # The result will be the Team object that has the team_id matching 

    # return the team name, # return the name of the team after finding the specific Team object based on above 
    team.team_name 
  end

  def fewest_tackles(season)
    game_ids_in_season = @games
    .select { |game| game.season == season } 
     # select iterates over each game in the @games array and checks if the season of the game matches the season argument 
     #It returns a new array with only those games that meet the condition.
    .map { |game| game.game_id }
    # map iterates over the filtered games and extracts the game_id from each game object. 
    # It returns a new array containing just the game_ids.
    .uniq  
    # uniq iterates through the array and returns a new array with all duplicate game_ids removed, 
    # ensuring each game_id appears only once.                   

  # 
  tackles_by_team = @game_teams
    .select { |game_team| game_ids_in_season.include?(game_team.game_id) } 
     # select iterates over each game_team in @game_teams, 
     #checking if its game_id is present in the game_ids_in_season array. 
     # It returns a new array containing only the game_team objects that match the condition.
    .group_by(&:team_id)   
     # group_by creates a hash where the keys are team_id values and the values are arrays of game_team objects that have the same team_id. 
     # it organizes all game_team records by the team they belong to                                              
    .transform_values { |game_teams| game_teams.sum(&:tackles) } 
     # transform_values iterates over the hash values (arrays of game_team objects). 
     # For each array, it calculates the sum of tackles for each game_team using sum(&:tackles). 
     # This results in a new hash where each key (team_id) maps to the total tackles made by that team.

  
  fewest_tackles_team_id = tackles_by_team.min_by { |_, total_tackles| total_tackles }&.first # & is a safe operator to avoid nil
    # For each pair, it evaluates the block provided (in this case, { |_, total_tackles| total_tackles }), which means it is looking at the total_tackles value. 
    # It returns the key-value pair where total_tackles is the smallest.
    # .first returns the first element of key-value pair. -Team id-
  team_names = @teams
    .each_with_object({}) { |team, hash| hash[team.team_id] = team.team_name } # For each team object, 
    # it adds an entry to the hash with the team_id as the key and team_name as the value. 
# each_with_object takes an initial object (in this case, 
# an empty hash {}) and yields each element of the array along with the accumulator (the hash) to the block.
  team_names[fewest_tackles_team_id] # is a variable that holds a team ID, which is used as the key to look up in the team_names hash.
  # team_names is a hash where keys are team IDs and values are team names, constructed like this
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


end
