require 'spec_helper'

RSpec.describe Games do
    before(:each) do
        @game_path = './data/games.csv'
        @stat_tracker = StatTracker.from_csv(@game_path)
        @games = Games.new(@game_path, @stat_tracker)
    end

    describe '#initialize' do
        it 'can initialize' do
            expect(@games).to be_an_instance_of(Games)
        end

        it 'has a game_id, season, type, and date_time' do
            expect(@games.game_id).to eq()
            expect(@games.season).to eq()
            expect(@games.type).to eq()
            expect(@games.date_time).to eq()
        end

        it 'has a away_team_id and a home_team_id' do
            expect(@games.away_team_id).to eq()
            expect(@games.home_team_id).to eq()
        end

        it 'has a away_goals and a home_goals' do
            expect(@games.away_goals).to eq()
            expect(@games.home_goals).to eq()
        end

        it 'has a venue, venue_link, and a tracker' do
            expect(@games.venue).to eq()
            expect(@games.venue_link).to eq()
            expect(@games.tracker).to eq()
        end
        
    end
end