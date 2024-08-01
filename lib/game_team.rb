class GameTeam

    attr_reader :game_id,
                :team_id,
                :hoa,
                :result,
                :settled_in,
                :head_coach,
                :goals,
                :shots,
                :tackles,
                :pim,
                :power_play_opportunities,
                :power_play_goals,
                :face_off_win_percentage,
                :giveaways,
                :takeaways

    def initialize(data)
        @game_id = data[:game_id]
        @team_id = data[:team_id]
        @hoa = data[:hoa]
        @result = data[:result]
        @settled_in = data[:settled_in]
        @head_coach = data[:head_coach]
        @goals = data[:goals].to_i
        @shots = data[:shots].to_i
        @tackles = data[:tackles].to_i
        @pim = data[:pim].to_i
        @power_play_opportunities = data[:powerplayopportunities].to_i
        @power_play_goals = data[:powerplaygoals].to_i
        @face_off_win_percentage = data[:faceoffwinpercentage].to_f
        @giveaways = data[:giveaways].to_i
        @takeaways = data[:takeaways].to_i
    end
end
