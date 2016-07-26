require 'stattleship'
require 'pp'


Game.delete_all
User.delete_all

User.create(email: 'tim@tim.com', password: 'timtim')
User.create(email: 'tom@tom.com', password: 'tomtom')
# u.password = 'timtim'
# u.save

Stattleship.configure do |config|
      config.api_token = '5faa60b51939bb1b58b5cc0594a2b12b'
    end
# Construct params for the fetch
query_params = Stattleship::Params::BaseballGamesParams.new

# use a slug, typically 'league-team_abbreviation'
# query_params.team_id = 'mlb-bos'

# may need to adjust this depending on time of year
query_params.season_id = 'mlb-2016'
query_params.status = 'upcoming'
query_params.on = 'today'

# fetch will automatically traverse the paginated response links
games = Stattleship::BaseballGames.fetch(params: query_params)

if games.length > 0
  # the populated object
  pp games.first

  # can access friendly helpers
  pp games.first.started_at.strftime('%b %e, %l:%M %p')

  # or, individual attributes
  games.each do |game|
    pp game.scoreline

    Game.create(
      label: game.label,
      full_name: game.name,
      home_team: "#{game.home_team.location} #{game.home_team.nickname}",
      away_team: "#{game.away_team.location} #{game.away_team.nickname}",
      start_time: game.started_at
      )
  end
end

  # Construct params for the fetch
query_params = Stattleship::Params::BaseballGamesParams.new

# use a slug, typically 'league-team_abbreviation'
# query_params.team_id = 'mlb-bos'

# may need to adjust this depending on time of year
query_params.season_id = 'mlb-2016'
# query_params.status = 'upcoming'
query_params.on = 'yesterday'

# fetch will automatically traverse the paginated response links
games = Stattleship::BaseballGames.fetch(params: query_params)

if games.length > 0
  # the populated object
  pp games.first

  # can access friendly helpers
  pp games.first.started_at.strftime('%b %e, %l:%M %p')

  # or, individual attributes
  games.each do |game|
    pp game.scoreline
    g = Game.find_by(full_name: game.name)
    if g
      g.update(
        home_team_score: game.home_team_score,
        away_team_score: game.away_team_score,
        finished: true,
        winning_team: "#{game.winning_team.location} #{game.winning_team.nickname}"
        )
    end
  end
end
