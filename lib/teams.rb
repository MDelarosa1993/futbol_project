class Teams
  attr_reader :team_id,
              :franchise_id,
              :team_name,
              :abbreviation,
              :stadium,
              :link,
              :tracker

  def initialize(data, tracker)
    @team_id = data[:team_id]
    @franchise_id = data[:franchiseId]
    @team_name = data[:teamName]
    @abbreviation = data[:abbreviation]
    @stadium = data[:Stadium]
    @link = data[:link]
    @tracker = tracker
  end
end
