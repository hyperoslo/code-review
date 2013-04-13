require "sinatra"
require "json"
require "pony"

configure do
  # A string describing the odds of a code review (e.g. "1:10").
  set :odds, ENV["ODDS"]

  # A list of strings describing e-mail addresses a code review may be addressed to.
  set :reviewers, ENV["REVIEWERS"].split(",")
end

Pony.options = {
  via: :smtp,
  via_options: {
    address: ENV["SMTP_HOST"],
    port: ENV["SMTP_PORT"],
    domain: ENV["SMTP_DOMAIN"],
    user_name: ENV['SMTP_USERNAME'],
    password: ENV['SMTP_PASSWORD'],
    authentication: :plain,
    enable_starttls_auto: true
  }
}

post "/" do
  data = JSON.parse request.body.read

  chance = Odds.parse settings.odds

  data["commits"].each do |commit|
    if rand(100) <= chance

      reviewers = settings.reviewers.reject do |reviewer|
        reviewer == commit["committer"]["email"]
      end

      reviewer = reviewers.sample

      if reviewer

        Pony.mail({
          to: reviewer,
          from: "Hyper <no-reply@hyper.no>",
          subject: "You've been selected to review #{commit["author"]["name"]}'s commit",
          body: erb(:reviewer_email, locals: {
            reviewee: commit["author"]["name"],
            url: commit["url"]
          })
        })

        Pony.mail({
          to: commit["committer"]["email"],
          from: "Hyper <no-reply@hyper.no>",
          subject: "Your commit has been selected for review",
          body: erb(:reviewee_email, locals: {
            reviewer: reviewer,
            url: commit["url"]
          })
        })

      end
    end
  end

  ""
end
