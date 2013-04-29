require "sinatra"
require "json"
require "pony"
require "httparty"
require "pygments"
require "gravatar"
require "odds"
require "gitlab"
require "reviewers"
require "premailer"

configure do
  set :odds, ENV["ODDS"]
  set :gitlab_private_token, ENV["GITLAB_PRIVATE_TOKEN"]
  set :reviewers, ENV["REVIEWERS"]
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

Reviewers.load settings.reviewers

post "/" do
  data = JSON.parse request.body.read

  data["commits"].each do |commit|
    if Odds.roll settings.odds
      reviewers = Reviewers.for commit["author"]["email"]

      if reviewer = reviewers.sample
        diff     = GitLab.diff commit["url"]
        gravatar = Gravatar.new commit["author"]["email"]

        html = erb :mail, locals: {
          gravatar: gravatar,
          commit: commit,
          diff: diff
        }

        mail = Premailer.new html, with_html_string: true

        Pony.mail({
          to: reviewer.email,
          from: "Hyper <no-reply@hyper.no>",
          cc: commit["author"]["email"],
          subject: "Code review",
          headers: {
            "Content-Type" => "text/html"
          },
          body: mail.to_inline_css
        })

      end
    end
  end

  ""
end
