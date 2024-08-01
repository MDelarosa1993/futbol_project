require 'spec_helper'

RSpec.describe Game do
    before(:each) do
        @data = {
            game_id:"2012030221",
            season:"20122013",
            type:"Postseason",
            date_time:"5/16/13",
            away_team_id:"3",
            home_team_id:"6",
            away_goals:"2",
            home_goals:"3",
            venue:"Toyota Stadium",
            venue_link:"/api/v1/venues/null"
        }
        @game = Game.new(@data)
    end

    describe '#initialize' do
        it 'can initialize' do
            expect(@game).to be_an_instance_of(Game)
        end

        it 'has a game_id, season, type, and date_time' do
            expect(@game.game_id).to eq("2012030221")
            expect(@game.season).to eq("20122013")
            expect(@game.type).to eq("Postseason")
            expect(@game.date_time).to eq("5/16/13")
        end

        it 'has a away_team_id and a home_team_id' do
            expect(@game.away_team_id).to eq("3")
            expect(@game.home_team_id).to eq("6")
        end

        it 'has a away_goals and a home_goals' do
            expect(@game.away_goals).to eq(2)
            expect(@game.home_goals).to eq(3)
        end

        it 'has a venue and venue_link' do
            expect(@game.venue).to eq("Toyota Stadium")
            expect(@game.venue_link).to eq("/api/v1/venues/null")
        end
    end
end
