$: << "lib"

require "application"
require "raven"

Raven.configure do |config|
  config.dsn = "http://68bdd62a4d394d7582991df0c7b22150:05c8dbd2d8f24bb28f42245f94df320e@sentry.hyper.no/9"
end

use Raven::Rack

run Sinatra::Application
