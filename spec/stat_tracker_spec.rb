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

  it 'counts games by season'do
    expect(@stat_tracker.count_of_games_by_season).to eq()
  end

  it 'counts all unique teams' do
    expect(@stat_tracker.count_of_teams).to eq()
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

  it "#count_of_teams" do
    expect(@stat_tracker.count_of_teams).to eq 32
  end

  it "#best_offense" do
    expect(@stat_tracker.best_offense).to eq "Reign FC"
  end

  it "#worst_offense" do
    expect(@stat_tracker.worst_offense).to eq "Utah Royals FC"
  end
end 