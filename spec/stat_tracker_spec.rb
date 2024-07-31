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

  describe '#average goals per game and season' do 
    it 'returns average goals per game' do 
      expect(@stat_tracker.average_goals_per_game).to eq 4.22
    end

    it 'returns average goals per season' do 
      season_id = {
      "20122013"=>4.12,
      "20162017"=>4.23,
      "20142015"=>4.14,
      "20152016"=>4.16,
      "20132014"=>4.19,
      "20172018"=>4.44
    }
    expect(@stat_tracker.average_goals_by_season).to eq(season_id)
    end
  end
end 