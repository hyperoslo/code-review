require "sinatra"
require "json"
require "pony"
require "httparty"
require "pygments"
require "gravatar"
require "odds"
require "git_service"
require "git_service/gitlab"
require "git_service/github"
require "reviewers"
require "premailer"

configure do
  set :odds, ENV["ODDS"]
  set :gitlab_private_token, ENV["GITLAB_PRIVATE_TOKEN"]
  set :reviewers, ENV["REVIEWERS"]
  set :sender, ENV["SENDER"]
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

get "/preview" do
  commit = {
    "id" => "2637cc7448594cdb8c5baac2d87c68a2f587a0c0",
    "message" => "Use mapbox v1.0.1 for all browsers",
    "timestamp" => "2011-12-12T14:27:31+02:00",
    "url" => "http://git.hyper.no/mesan-code/commit/2637cc7448594cdb8c5baac2d87c68a2f587a0c0",
    "author" => {
      "name" => "Johannes Gorset",
      "email" => "jgorset@gmail.com"
    }
  }

  diff     = GitLab.diff commit["url"]
  gravatar = Gravatar.new commit["author"]["email"]

  html = erb :mail, locals: {
    gravatar: gravatar,
    commit: commit,
    diff: diff,
  }

  mail = Premailer.new html, with_html_string: true

  mail.to_inline_css
end

post "/" do
  content = from_github? ? params[:payload] : request.body.read
  data = JSON.parse content

  repository_name = data["repository"]["name"]
  branch = data["ref"].split("/").last

  data["commits"].each do |commit|
    if Odds.roll settings.odds
      reviewers = Reviewers.for commit["author"]["email"]

      if reviewer = reviewers.sample
        diff     = GitService.diff commit["url"]
        gravatar = Gravatar.new commit["author"]["email"]

        html = erb :mail, locals: {
          gravatar: gravatar,
          commit: commit,
          diff: diff
        }

        mail = Premailer.new html, with_html_string: true

        Pony.mail({
          to: reviewer.email,
          from: settings.sender,
          reply_to: commit["author"]["email"],
          cc: commit["author"]["email"],
          subject: "Code review for #{repository_name}/#{branch}@#{commit["id"][0,7]}",
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

def from_github?
  params.has_key? 'payload'
end
