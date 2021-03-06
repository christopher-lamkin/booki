require 'stattleship-ruby'

Stattleship.configure do |config|
config.api_token = '5faa60b51939bb1b58b5cc0594a2b12b'
end

dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require File.join(dir, 'stattleship')
require 'pp'

# Construct params for the fetch
query_params = Stattleship::Params::BaseballGamesParams.new

# use a slug, typically 'league-team_abbreviation'
query_params.team_id = 'mlb-bos'

# may need to adjust this depending on time of year
query_params.season_id = 'mlb-2016'
query_params.status = 'upcoming'

# fetch will automatically traverse the paginated response links
games = Stattleship::BaseballGames.fetch(params: query_params)

# the populated object
pp games.first

# can access friendly helpers
pp games.first.started_at.strftime('%b %e, %l:%M %p')

# or, individual attributes
games.each do |game|
  pp game.scoreline
end