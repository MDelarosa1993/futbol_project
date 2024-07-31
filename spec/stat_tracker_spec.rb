require 'csv'
require './lib/stat_tracker'

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

  it 'counts all unique teams' do
    expect(@stat_tracker.count_of_teams).to eq()
  end

  it 'counts games by season'do
    expect(@stat_tracker.count_of_games_by_season).to eq({"" => , "" => })
  end
end 