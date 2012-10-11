require "sinatra"
require "json"
require "pony"

# A string describing the odds of a code review (e.g. "1:10").
ODDS       = ENV["ODDS"]

# A string describing a comma-separated list of e-mail addresses
# a code review might be addressed to.
RECIPIENTS = ENV["RECIPIENTS"].split ","

Pony.options = {
  via: :smtp,
  via_options: {
    address: 'smtp.sendgrid.net',
    port: '587',
    domain: 'heroku.com',
    user_name: ENV['SENDGRID_USERNAME'],
    password: ENV['SENDGRID_PASSWORD'],
    authentication: :plain,
    enable_starttls_auto: true
  }
}

post "/" do
  data = JSON.parse request.body.read

  commits = data["commits"]

  x, y = ODDS.split ":"
  chance = ((x.to_f / (y.to_f - 1)) * 100) * commits.size

  commit = commits.sample

  if rand(100) <= chance
    Pony.mail({
      to: RECIPIENTS.sample,
      from: "Hyper <no-reply@hyper.no>",
      subject: "You've been selected to review!",
      body: erb(:reviewer_email, locals: {
        reviewee: commit["author"]["name"],
        url: commit["url"]
      })
    })
  end
end
