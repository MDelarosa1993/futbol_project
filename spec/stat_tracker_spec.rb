require 'spec_helper'

RSpec.describe StatTracker do 
  before(:all) do 
    @game_path = './data/games.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams.csv'

    @locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(@locations)
  end

  describe '#StatTracker' do 
    it 'creates an instance of stattracker' do 
      expect(@stat_tracker).to be_an_instance_of(StatTracker)
    end
  end

  describe 'highest total score and lowest total' do 
    it 'returns highest score' do 
      expect(@stat_tracker.highest_total_score).to eq(11)
    end
  end

  it 'returns lowest score' do 
    expect(@stat_tracker.lowest_total_score).to eq(0)
  end

  it 'calculates total score betwen highest and lowest score' do 
    total_scores = @stat_tracker.total_score
    expect(@stat_tracker.total_score).to eq(total_scores)
  end

  it "#percentage_home_wins" do
    expect(@stat_tracker.percentage_home_wins).to eq 0.44
  end

  it 'calculates percentage of visitor wins' do
    expect(@stat_tracker.percentage_visitor_wins).to eq 0.36
  end

  it "#percentage_ties" do
    expect(@stat_tracker.percentage_ties).to eq 0.20
  end

  it "#average_goals_per_game" do
    expect(@stat_tracker.average_goals_per_game).to eq 4.22
  end

  it "#average_goals_by_season" do
    expected = {
      "20122013"=>4.12,
      "20162017"=>4.23,
      "20142015"=>4.14,
      "20152016"=>4.16,
      "20132014"=>4.19,
      "20172018"=>4.44
    }
    expect(@stat_tracker.average_goals_by_season).to eq expected
  end

  it "#most_tackles" do
    expect(@stat_tracker.most_tackles("20132014")).to eq "FC Cincinnati"
    expect(@stat_tracker.most_tackles("20142015")).to eq "Seattle Sounders FC"
  end

  it "#fewest_tackles" do
    expect(@stat_tracker.fewest_tackles("20132014")).to eq "Atlanta United"
    expect(@stat_tracker.fewest_tackles("20142015")).to eq "Orlando City SC"
  end
  
  describe '#most_accurate_team' do
    it 'is the team name with the best ratio of shots to goals for the season' do
      expect(@stat_tracker.find_game_teams_by_season("2012")).to be_a(Array)
      expect(@stat_tracker.most_accurate_team("20172018")).to eq("Portland Timbers")
      expect(@stat_tracker.most_accurate_team("20142015")).to eq("Toronto FC")
      expect(@stat_tracker.most_accurate_team("20132014")).to eq("Real Salt Lake")
    end
  end

  describe '#least_accurate_team' do
    it 'is the team name with the worst ratio of shots to goals by season' do
      expect(@stat_tracker.least_accurate_team("20142015")).to eq("Columbus Crew SC")
      expect(@stat_tracker.least_accurate_team("20132014")).to eq("New York City FC")
    end
  end

  it "#count_of_teams" do
    expect(@stat_tracker.count_of_teams).to eq 32
  end

  it "#best_offense" do
    expect(@stat_tracker.best_offense).to eq "Reign FC"
  end

  it "#worst_offense" do
    expect(@stat_tracker.worst_offense).to eq "Utah Royals FC"
  end

  it "#count_of_games_by_season" do
    expected = {
      "20122013"=>806,
      "20162017"=>1317,
      "20142015"=>1319,
      "20152016"=>1321,
      "20132014"=>1323,
      "20172018"=>1355
    }
  expect(@stat_tracker.count_of_games_by_season).to eq expected
  end

  it 'returns games by season' do 
    games_by_season = @stat_tracker.filter_games_by_season("20132014")
    expect(@stat_tracker.filter_games_by_season(("20132014"))).to eq(games_by_season)
  end

  it 'returns games by season' do 
    game_id_by_season = @stat_tracker.get_game_ids_by_season("20132014")
    expect(@stat_tracker.get_game_ids_by_season(("20132014"))).to eq(game_id_by_season)
  end

  it 'returns gameteams by game id' do 
    game_team_id = @stat_tracker.filter_game_teams_by_game_ids("6")
    expect(@stat_tracker.filter_game_teams_by_game_ids(("6"))).to eq(game_team_id)
  end

  it 'returns team by id' do 
    team_id = @stat_tracker.find_team_by_id('1')
    expect(@stat_tracker.find_team_by_id('1')).to eq(team_id)
  end

  it 'retruns a hash with team names' do 
    hash = @stat_tracker.construct_team_names_hash
    expect(@stat_tracker.construct_team_names_hash).to eq(hash)
  end

  it 'returns the highest scoring visitor' do 
    expect(@stat_tracker.highest_scoring_visitor).to eq("FC Dallas")
  end

  it 'returns the highest scoring home team' do
    expect(@stat_tracker.highest_scoring_home_team).to eq("Reign FC")
  end

  it 'retursn the lowest scoring visitor' do
    expect(@stat_tracker.lowest_scoring_visitor).to eq("San Jose Earthquakes")
  end

  it 'returns the lowest scoring home team' do 
    expect(@stat_tracker.lowest_scoring_home_team).to eq("Utah Royals FC")
  end
end
