require 'spec_helper'

RSpec.describe Teams do
    before(:each) do
        @team_path = './data/teams.csv'
        @stat_tracker = StatTracker.from_csv(@team_path)
        @teams = Teams.new(@teams_path, @stat_tracker)
    end

    describe '#initialize' do
        it 'can initialize' do
            expect(@teams).to be_an_instance_of(Teams)
        end

        it 'has a team_id, franchise_id, team_name, and abbreviation' do
            expect(@teams.team_id).to eq(1)
            expect(@teams.franchise_id).to eq(23)
            expect(@teams.team_name).to eq("Atlanta United")
            expect(@teams.abbreviation).to eq("ALT")
        end

        it 'has a stadium and a link' do
            expect(@teams.stadium).to eq("Mercedes-Benz Stadium")
            expect(@teams.link).to eq("/api/v1/teams/1")
        end
    end
end
