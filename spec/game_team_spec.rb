require 'spec_helper'

RSpec.describe GameTeam do
    before(:each) do
        @data = {
            game_id:"2012030221",
            team_id:"3",
            hoa:"away",
            result:"LOSS",
            settled_in:"OT",
            head_coach:"John Tortorella",
            goals:"2",
            shots:"8",
            tackles:"44",
            pim:"8",
            powerplayopportunities:"3",
            powerplaygoals:"0",
            faceoffwinpercentage:"44.8",
            giveaways:"17",
            takeaways:"7"
        }
        @game_team = GameTeam.new(@data)
    end

    describe '#initialize' do
        it 'can initialize' do
            expect(@game_team).to be_an_instance_of(GameTeam)
        end

        it 'has a game_id, team_id, and hoa' do
            expect(@game_team.game_id).to eq("2012030221")
            expect(@game_team.team_id).to eq("3")
            expect(@game_team.hoa).to eq("away")
        end

        it 'has results, settled_in, and a head_coach' do
            expect(@game_team.result).to eq("LOSS")
            expect(@game_team.settled_in).to eq("OT")
            expect(@game_team.head_coach).to eq("John Tortorella")
        end

        it 'has goals, shots, and tackles' do
            expect(@game_team.goals).to eq(2)
            expect(@game_team.shots).to eq(8)
            expect(@game_team.tackles).to eq(44)
        end

        it 'has pim, power_play_opportunities, and power_play_goals' do
            expect(@game_team.pim).to eq(8)
            expect(@game_team.power_play_opportunities).to eq(3)
            expect(@game_team.power_play_goals).to eq(0)
        end

        it 'has face_off_win_percentage, giveaways, and takeaways' do
            expect(@game_team.face_off_win_percentage).to eq(44.8)
            expect(@game_team.giveaways).to eq(17)
            expect(@game_team.takeaways).to eq(7)
        end
    end
end