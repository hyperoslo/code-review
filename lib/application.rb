require "sinatra"
require "json"
require "pony"
require "httparty"
require "pygments"
require "gravatar"
require "gitlab"

configure do
  # A string describing the odds of a code review (e.g. "1:10").
  set :odds, ENV["ODDS"]

  # A string describing a private token from GitLab.
  set :gitlab_private_token, ENV["GITLAB_PRIVATE_TOKEN"]

  # A list of strings describing e-mail addresses a code review may be addressed to.
  raw_reviewers = ENV["REVIEWERS"].split(",")
  reviewers = []
  raw_reviewers.each do |reviewer|
    personal, work = reviewer.split(":")
    reviewers << { personal: personal, work: work }
  end

  set :reviewers, reviewers
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

GitLab.configure do |config|
  config.private_token = settings.gitlab_private_token
end

get "/preview" do
  commit = {
    "id" => "524127ddd12c845a85403fe40e2c333afd19434b",
    "message" => "Make Subscription#preset accessible",
    "timestamp" => "2011-12-12T14:27:31+02:00",
    "url" => "http://git.hyper.no/hyper/hyper-alerts-code/commit/524127ddd12c845a85403fe40e2c333afd19434b",
    "author" => {
      "name" => "Johannes Gorset",
      "email" => "johannes@hyper.no"
    }
  }

  diff     = GitLab.diff commit["url"]
  gravatar = Gravatar.new commit["author"]["email"]

  erb :mail, locals: {
    gravatar: gravatar,
    commit: commit,
    diff: diff
  }
end

post "/" do
  data = JSON.parse request.body.read

  chance = Odds.parse settings.odds

  data["commits"].each do |commit|
    if rand(100) <= chance

      reviewers = settings.reviewers.reject do |reviewer|
        reviewer.has_value? commit["author"]["email"]
      end

      reviewer = reviewers.sample

      if reviewer
        diff     = GitLab.diff commit["url"]
        gravatar = Gravatar.new commit["author"]["email"]

        Pony.mail({
          to: reviewer[:work],
          from: "Hyper <no-reply@hyper.no>",
          cc: commit["author"]["email"],
          subject: "Code review",
          headers: {
            "Content-Type" => "text/html"
          },
          body: erb(:mail, locals: {
            gravatar: gravatar,
            commit: commit,
            diff: diff,
            url: commit["url"]
          })
        })

      end
    end
  end

  ""
end
